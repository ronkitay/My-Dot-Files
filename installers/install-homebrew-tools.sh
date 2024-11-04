#!/bin/sh

SCRIPT_DIR=$(dirname "$0")

CONFIG_DIR=${HOME}/.config/ron

HOMEBREW_CONFIG_FILE=${CONFIG_DIR}/homebrew

function logStep() {
  echo "${BRIGHT}${GREEN}Step ${CURRENT_STEP}/${STEP_COUNT}: $1${NORMAL}"
  let CURRENT_STEP=CURRENT_STEP+1
}

function installOrUpdateHomebrew() {
    logStep "Installing/Updating Homebrew - https://brew.sh/"
    if [ -f /usr/local/bin/brew ] || [ -f /opt/homebrew/bin/brew ] ; 
    then
        brew update;
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    HOMEBREW_HOME=$(dirname $(command -v brew))
}

function installOrUpdateFormulae() {
    title=$1
    url=$2
    formula=$3
    tap=$4

    logStep "Installing/Updating $title ($formula) - $url"

    if [ -n "$tap" ]; 
    then
        [[ $(brew tap $tap > /dev/null 2>&1) -ne 0 ]] && brew tap $tap
    fi

    if [ -f ${HOMEBREW_HOME}/$formula ]; 
    then
        brew upgrade $formula;
    else
        brew install $formula;
    fi
}

if [ ! -f ${HOMEBREW_CONFIG_FILE} ]; 
then
  echo "${BRIGHT}Could not find the config file ${RED}${HOMEBREW_CONFIG_FILE}${WHITE} - aborting"
  exit 1
fi


input_file="${HOMEBREW_CONFIG_FILE}"
let STEP_COUNT="$(cat $input_file | egrep -v '^\s+$'| wc -l)"+2
let CURRENT_STEP=1

installOrUpdateHomebrew

while IFS=';' read -r title url formula tap || [ -n "$title" ]; do
    [ -z "$title" ] && continue
    
    installOrUpdateFormulae "$title" "$url" "$formula" "$tap"
done < "$input_file"

# logStep "Installing/Updating asdf plugins - ${SCRIPT_DIR}/install-asdf-plugins.sh"
#${SCRIPT_DIR}/install-asdf-plugins.sh
