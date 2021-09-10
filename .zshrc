#################################################
##             csitools integration            ##
#################################################

csitools --check

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:$HOME/utils/apache-maven-3.5.4/bin/mvn

# Path to your oh-my-zsh installation.
export ZSH="/Users/rkitay/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# echo -ne "\e]1;${PWD: -10}\a"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="[%F] [%T]"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git virtualenv fzf )

## FZF plugin configs

export FZF_COMPLETION_TRIGGER='//'

export FZF_BASE=/usr/local/bin/fzf


export FZF_DEFAULT_COMMAND='fd'

export FZF_DEFAULT_OPTS="-m --border --layout=reverse --preview 'bat --style=numbers --color=always --line-range :500 {}'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

_fzf_complete_grevert() {
  _fzf_complete --multi --reverse --prompt="revert> " -- "$@" < <(git status | egrep "deleted|modified" | awk '{$1=""; print $NF}')
}

_fzf_complete_gadd() {
  _fzf_complete --multi --reverse --prompt="add> " -- "$@" < <(git st --short | awk '{print($NF)}')
}

source $ZSH/oh-my-zsh.sh

SHARE_HISTORY=off

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

bindkey "[D" backward-word
bindkey "[C" forward-word

source ${HOME}/.aliases

#################################################
##               PERFORCE SETTINGS             ##
#################################################

export P4USER=rkitay
export P4DIFF=/usr/bin/diff
#export P4PORT="rsh:crackpipe ssh -2 -a -c blowfish -l p4ssh -q -x p4p.munich.corp.akamai.com /bin/true"
# export P4PORT="rsh:crackpipe ssh -2 -a -l p4ssh -q -x perforce.akamai.com /bin/true"
export P4PORT="rsh:ssh -2 -a -l p4source -q -x p4p.telaviv.corp.akamai.com"
export P4CONFIG=".perforce"

#################################################
##               PATH SETTINGS              ##
#################################################

# Add my scripts to the path
export PATH="${HOME}/.scripts:${PATH}"

# Add Maven to the path
export PATH="${PATH}:/Users/rkitay/utils/apache-maven-3.5.4/bin"

# Put Go in the path
export PATH="${PATH}:/usr/local/go/bin"

# Confluent Cloud CLI
export PATH="${PATH}:/Users/rkitay/tools/confluent-kafka/bin"

#################################
##             java            ##
#################################
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home"
# export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0`

#################################
##             K8S             ##
#################################

# Taken from: https://kubernetes.io/docs/reference/kubectl/cheatsheet/ 
source <(kubectl completion zsh)

source <(helm completion zsh)

#################################
##             jenv            ##
#################################

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

complete -W "envs list cm fm ul pg padawan la-ddc la-dlr nperf ssqa chi sj" csi

# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# autoload -U select-word-style
# select-word-style bash

# backward-kill-dir () {
#     local WORDCHARS=${WORDCHARS/\/}
#     zle backward-kill-word
# }
# zle -N backward-kill-dir
# bindkey '^[^?' backward-kill-dir
