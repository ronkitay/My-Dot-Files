#################################################
##                COLOR SETTINGS               ##
#################################################
export CLICOLOR=1
export LSCOLORS=CxFxxxxxBxxxxxxxxxxxxx

source ${HOME}/.aliases

export PATH=${HOME}/.scripts:${PATH}

#################################################
##                PERSONAL REMINDER            ##
#################################################
[[ -f ${HOME}/loginReminder ]] && {
	REMINDER=$(cat ${HOME}/loginReminder)
	printf "\n$(tput bold)Reminder: $(tput setaf 2)${REMINDER}$(tput sgr0)\n\n"
}

