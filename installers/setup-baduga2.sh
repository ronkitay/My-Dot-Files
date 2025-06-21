#!/bin/sh


printf "Installing asdf in %s\n" "$TOOLS_DIR"
TOOLS_DIR="$HOME/tools"
ASDF_RELEASES_API="https://api.github.com/repos/asdf-vm/asdf/releases/latest"
printf "Fetching the latest release information from %s\n" "$ASDF_RELEASES_API"

ASSET_URL=$(curl -s $ASDF_RELEASES_API | jq -r '.assets[] | select(.name | endswith("linux-amd64.tar.gz")) | .browser_download_url')
printf "Latest release asset URL: %s\n" "$ASSET_URL"

mkdir -p "$TOOLS_DIR"
curl -L "$ASSET_URL" | tar -xz -C "$TOOLS_DIR"