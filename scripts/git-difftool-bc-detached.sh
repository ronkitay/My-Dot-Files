#!/bin/sh

##########################################################################
### git difftool wrapper: Beyond Compare, detached (non-blocking) ###
##########################################################################
#
# git difftool calls this with: LOCAL REMOTE.
#
# Key fact (verified): for a working-tree diff git passes
#   LOCAL  = a throwaway snapshot under .../git-blob-XXXX/   (git deletes it on return)
#   REMOTE = the REAL working-tree file                       (NOT a temp)
# so we must copy ONLY the git-blob snapshots and pass the real file through
# untouched — that keeps the right-hand side LIVE and editable: edits you make
# in Beyond Compare (or in your editor) act on the actual file and save.
#
# Non-blocking without losing files: bcomp/bcompare are the same binary, and
# bcomp *blocks until its tab closes*. We run it in a background subshell, so
# the terminal is free immediately AND bcomp returning is our signal to delete
# exactly this diff's copies — no fixed-timeout guessing.

LOCAL="$1"
REMOTE="$2"

TEMP_ROOT=/tmp/git-bc-diff
mkdir -p "$TEMP_ROOT"

# Backstop only: reap copies orphaned by a crash/kill that skipped the on-close
# cleanup below. 7 days, so it can NEVER delete a copy for a diff tab you left
# open (those are cleaned the instant the tab closes).
find "$TEMP_ROOT" -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec rm -rf {} + 2>/dev/null

SESS="$TEMP_ROOT/$$-$RANDOM"
mkdir -p "$SESS"

# Copy a side only if it's a transient git snapshot; pass real files straight
# through so they stay live and writable.
prep() {
  case "$1" in
    */git-blob-*)
      copy="$SESS/$2-$(basename "$1")"
      cp "$1" "$copy"
      printf '%s' "$copy"
      ;;
    *)
      printf '%s' "$1"
      ;;
  esac
}

L=$(prep "$LOCAL"  L)
R=$(prep "$REMOTE" R)

# Detached; SESS holds only OUR copies (never the real file), so cleaning it on
# close is safe. If nothing was copied, SESS is just an empty dir we remove.
(
  /usr/local/bin/bcomp "$L" "$R"
  rm -rf "$SESS"
) >/dev/null 2>&1 &
