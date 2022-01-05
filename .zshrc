source ${HOME}/.bindkey.settings
source ${HOME}/.fzf.settings

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

HIST_STAMPS="[%F] [%T]"

plugins=(jenv gradle git virtualenv fzf kubectl kubectx helm)

SHARE_HISTORY=off

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# autoload -U select-word-style
# select-word-style bash

# backward-kill-dir () {
#     local WORDCHARS=${WORDCHARS/\/}
#     zle backward-kill-word
# }
# zle -N backward-kill-dir
# bindkey '^[^?' backward-kill-dir