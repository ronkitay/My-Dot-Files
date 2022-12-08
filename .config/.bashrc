# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

export EDITOR='vim'

export HISTSIZE=10000
export HISTTIMEFORMAT="[%F] [%T]  "


source ${HOME}/.aliases/.define.colors
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
source ${HOME}/.aliases/.util.aliases


