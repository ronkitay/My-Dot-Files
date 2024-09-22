#!/bin/sh

SCRIPT_DIR=$(dirname "$0")
HOMEBREW_HOME=/opt/homebrew/bin

function logStep() {
  echo "${BRIGHT}${GREEN}Step ${CURRENT_STEP}/${STEP_COUNT}: $1${NORMAL}"
  let CURRENT_STEP=CURRENT_STEP+1
}

function installOrUpdateHomebrew() {
    logStep "Installing/Updating Homebrew - https://brew.sh/"
    if [ -f ${HOMEBREW_HOME}/brew ]; 
    then
        brew update;
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
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


input_file="${SCRIPT_DIR}/homebrew-tools.csv"
let STEP_COUNT="$(cat $input_file | egrep -v '^\s+$'| wc -l)"+2
let CURRENT_STEP=1

installOrUpdateHomebrew

while IFS=';' read -r title url formula tap || [ -n "$title" ]; do
    [ -z "$title" ] && continue
    
    installOrUpdateFormulae "$title" "$url" "$formula" "$tap"
done < "$input_file"

logStep "Installing/Updating asdf plugins - ${SCRIPT_DIR}/install-asdf-plugins.sh"
${SCRIPT_DIR}/install-asdf-plugins.sh
