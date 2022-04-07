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

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh