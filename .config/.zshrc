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
plugins=(asdf fzf git golang gradle helm kubectl kubectx virtualenv zsh-autosuggestions terraform taskwarrior)
ZSH_THEME="powerlevel10k/powerlevel10k"

source $ZSH/oh-my-zsh.sh

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

if [[ -d "${PERSONAL_CODE_ROOT}" ]]; then
  GO_BACK=$(pwd)
  cd ${PERSONAL_CODE_ROOT}

  complete -W "$(ls ${PERSONAL_CODE_ROOT})" gopersonal
  function gopersonal() {
    rgb 158 100 180
    cd ${PERSONAL_CODE_ROOT}
    smart_change_dir_to_child $*
  }

  for dir_name in `ls`; 
  do 
    if [[ -f "${PERSONAL_CODE_ROOT}/${dir_name}/.go.here" ]];
    then
      BASE_DIR=${PERSONAL_CODE_ROOT} source ${PERSONAL_CODE_ROOT}/${dir_name}/.go.here
    fi
  done

  CFI_HOME=${PERSONAL_CODE_ROOT}/code-for-israel
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

if [[ -d "${WORK_CODE_ROOT}" ]]; then
  complete -W "$(cd ${WORK_CODE_ROOT} && fd --strip-cwd-prefix -t d -H --max-depth 1 -E .git)" gowork
  function gowork() {
    rgb 255 0 255
    cd ${WORK_CODE_ROOT}
    smart_change_dir_to_child $*
  }
fi

if [[ -d "${OPENSOURCE_CODE_ROOT}" ]]; then
  complete -W "$(cd ${OPENSOURCE_CODE_ROOT} && fd --strip-cwd-prefix -t d -H --max-depth 1 -E .git)" goopensource
  function goopensource() {
    rgb 20 90 20
    cd ${OPENSOURCE_CODE_ROOT}
    smart_change_dir_to_child $*
  }
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

[ -f /opt/homebrew/bin/autojump  ] && . /opt/homebrew/Cellar/autojump/22.5.3_3/share/autojump/autojump.zsh

[ -f  /opt/homebrew/bin/ranger ] && alias rr='/opt/homebrew/bin/ranger'

[ -f  /opt/homebrew/bin/task ] && alias t='/opt/homebrew/bin/task'

export PATH=${HOME}/tools:$PATH
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

source <(griffin shell-integration)

if [[ "${TERM_PROGRAM}" == "iTerm.app" && "${PIPENV_ACTIVE}" != "1" ]]; 
then
  echo "${BRIGHT}Active Tasks${NORMAL}"
  echo "${BRIGHT}============${NORMAL}"
  task active
  echo "\n${BRIGHT}You have ${GREEN}$(task count +READY)${WHITE} tasks to work on${NORMAL}\n"
fi

alias vi=nvim
