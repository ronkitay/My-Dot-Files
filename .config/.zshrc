# ============================================================================
# Zinit Setup
# ============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# ============================================================================
# Basic Settings
# ============================================================================
export EDITOR='nvim'
alias vi=nvim
export LANG=en_US.UTF-8
HIST_STAMPS="[%F] [%T]"
unsetopt SHARE_HISTORY

if [[ "$(uname)" == "Linux" ]];
then
    alias bat='batcat'
    export PAGER="batcat -p"
    alias fd='fdfind'
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
else
    export PAGER="bat -p"
fi

if [[ $TERM_PROGRAM == "iTerm.app" ]]; then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

path=(
  "${HOME}/tools"
  "${HOME}/.codeium/windsurf/bin"
  "${HOME}/.antigravity/antigravity/bin"
  $path
)

export MY_DOCKER_IMAGES_REPO=ronkitay

[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -f /home/linuxbrew/.linuxbrew/bin/brew ] &&  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

source ${HOME}/.bindkey.settings
source ${HOME}/.fzf.settings
source ${HOME}/.man.settings

# ============================================================================
# Zinit Plugins
# ============================================================================

# Oh-My-Zsh libs (essential functionality)
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# Oh-My-Zsh plugins (loaded as snippets for speed)
zinit snippet OMZP::asdf
zinit snippet OMZP::git
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::virtualenv
zinit snippet OMZP::taskwarrior
zinit snippet OMZP::helm
zinit snippet OMZP::fzf

# Third-party plugins (turbo mode for faster startup)
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# ============================================================================
# Completion Setup (after plugins)
# ============================================================================
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zinit cdreplay -q

# Remove `mcd` autocompletion as it conflicts with mine and I do not use it .
compdef -d mcd

# Terraform completions (must be after compinit)
if (( $+commands[terraform] )); then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C terraform terraform
fi

# Terragrunt completions (must be after compinit)
if (( $+commands[terragrunt] )); then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C terragrunt terragrunt
fi

source ${HOME}/.aliases/.define.colors
source ${HOME}/.aliases/.aws.aliases
source ${HOME}/.aliases/.bat.aliases
source ${HOME}/.aliases/.common.aliases
source ${HOME}/.aliases/.cd.aliases
source ${HOME}/.aliases/.gcp.aliases
source ${HOME}/.aliases/.git.aliases
source ${HOME}/.aliases/.gradle.aliases
source ${HOME}/.aliases/.iterm.aliases
source ${HOME}/.aliases/.java.aliases
source ${HOME}/.aliases/.k8s.aliases
source ${HOME}/.aliases/.mac.aliases
source ${HOME}/.aliases/.mvn.aliases
source ${HOME}/.aliases/.p4.aliases
source ${HOME}/.aliases/.python.aliases
source ${HOME}/.aliases/.taskwarrior.aliases
source ${HOME}/.aliases/.util.aliases

export CODE_ROOT="${HOME}/code"
export PERSONAL_CODE_ROOT="${CODE_ROOT}/personal"
export OPENSOURCE_CODE_ROOT="${CODE_ROOT}/opensource"
export WORK_CODE_ROOT="${CODE_ROOT}/work"

if [[ -d ${PERSONAL_CODE_ROOT:-} ]]; then
  for file in "${PERSONAL_CODE_ROOT}"/*/{.go.here,.scripts}; do
    [[ -f $file ]] || continue
    BASE_DIR=$PERSONAL_CODE_ROOT source "$file"
  done
fi

${DOT_FILES_HOME}/scripts/uptimeChecker

if [[ -f ${HOME}/.zshrc.local ]]; then
  source ${HOME}/.zshrc.local
fi

command -v ranger >/dev/null 2>&1 && alias rr='ranger'
command -v task >/dev/null 2>&1 && alias t='task'

source <(griffin shell-integration)

if [[ "${PIPENV_ACTIVE}" != "1" && "${TERMINAL_EMULATOR}" != "JetBrains-JediTerm" && "${TERM_PROGRAM}" != "vscode" ]];
then
  STATE_FILE="${HOME}/.task/.state"
  TASK_DB="$HOME/.task/taskchampion.sqlite3"
  if [ ! -f "$STATE_FILE" ]; # || [ "$STATE_FILE" -ot "$TASK_DB" ];
  then
    task count +READY +ACTIVE > "${STATE_FILE}" 2> /dev/null
    task count +READY -ACTIVE >> "${STATE_FILE}" 2> /dev/null
  fi

  ACTIVE_TASKS=$(head -n 1 "${STATE_FILE}")
  READY_TASKS=$(tail -n 1 "${STATE_FILE}")
  echo "\n${BRIGHT}You are working on ${GREEN}${ACTIVE_TASKS}${WHITE} tasks and have another ${GREEN}${READY_TASKS}${WHITE} pending tasks to work on${NORMAL}\n"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
