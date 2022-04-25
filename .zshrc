test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export EDITOR='vim'
HIST_STAMPS="[%F] [%T]"

source ${HOME}/.bindkey.settings
source ${HOME}/.fzf.settings

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

SHARE_HISTORY=off
plugins=(jenv gradle git virtualenv fzf kubectl kubectx helm)
ZSH_THEME="powerlevel10k/powerlevel10k"

source $ZSH/oh-my-zsh.sh

source ${HOME}/.aliases

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


