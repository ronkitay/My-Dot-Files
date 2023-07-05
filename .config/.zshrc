if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

export MY_DOCKER_IMAGES_REPO=ronkitay

export EDITOR='vim'
HIST_STAMPS="[%F] [%T]"

[ -f /opt/homebrew/bin/brew ] &&  eval "$(/opt/homebrew/bin/brew shellenv)"

source ${HOME}/.bindkey.settings
source ${HOME}/.fzf.settings
source ${HOME}/.man.settings

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

SHARE_HISTORY=off
plugins=(asdf gradle git virtualenv fzf kubectl kubectx helm)
ZSH_THEME="powerlevel10k/powerlevel10k"

source $ZSH/oh-my-zsh.sh

source ${HOME}/.aliases/.define.colors
source ${HOME}/.aliases/.aws.aliases
source ${HOME}/.aliases/.bat.aliases
source ${HOME}/.aliases/.common.aliases
source ${HOME}/.aliases/.cd.aliases
source ${HOME}/.aliases/.git.aliases
source ${HOME}/.aliases/.iterm.aliases
source ${HOME}/.aliases/.java.aliases
source ${HOME}/.aliases/.k8s.aliases
source ${HOME}/.aliases/.mac.aliases
source ${HOME}/.aliases/.mvn.aliases
source ${HOME}/.aliases/.p4.aliases
source ${HOME}/.aliases/.python.aliases
source ${HOME}/.aliases/.util.aliases

PERSONAL_HOME=${HOME}/Personal

if [[ -d "${PERSONAL_HOME}" ]]; then
  GO_BACK=$(pwd)
  cd ${PERSONAL_HOME}

  complete -W "$(ls ${PERSONAL_HOME})" gopersonal
  function gopersonal() {
    rgb 158 100 180
    cd ${PERSONAL_HOME}
    smart_change_dir_to_child $*
  }

  for dir_name in `ls`; 
  do 
    if [[ -f "${PERSONAL_HOME}/${dir_name}/.go.here" ]];
    then
      BASE_DIR=${PERSONAL_HOME} source ${PERSONAL_HOME}/${dir_name}/.go.here
    fi
  done

  CFI_HOME=${PERSONAL_HOME}/code-for-israel
  if [[ -d "${CFI_HOME}" ]]; then
    complete -W "$(ls ${CFI_HOME})" gocfi
    function gocfi() {
      rgb 88 10 120
      cd ${CFI_HOME}
      smart_change_dir_to_child $*
    }

    OVRIM_HOME=${CFI_HOME}/ovrim
    if [[ -d "${OVRIM_HOME}" ]]; then
      complete -W "$(ls ${OVRIM_HOME})" goovrim
      function goovrim() {
        rgb 88 10 120
        cd ${OVRIM_HOME}
        smart_change_dir_to_child $*
      }
    fi    
  fi

  cd ${GO_BACK}
fi

NOTES_DIR="${HOME}/OneDrive/Notes"

if [[ -d "${NOTES_DIR}" ]]; then
  function gonotes() {
      cd "${NOTES_DIR}"
  }
fi

${DOT_FILES_HOME}/.scripts/uptimeChecker

if [[ -f ${HOME}/.zshrc.local ]]; then
  source ${HOME}/.zshrc.local
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

[ -f /usr/local/bin/ranger ] && alias rr='/usr/local/bin/ranger'

export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH
