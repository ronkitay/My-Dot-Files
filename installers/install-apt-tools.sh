#!/bin/sh

SCRIPT_DIR=$(dirname "$0")

CONFIG_DIR=${HOME}/.config/ron

APT_CONFIG_FILE=${CONFIG_DIR}/apt-get

BRIGHT="\033[1m"
GREEN="\033[32m"
RED="\033[31m"
WHITE="\033[37m"
NORMAL="\033[0m"

logStep() {
  echo "${BRIGHT}${GREEN}Step ${CURRENT_STEP}/${STEP_COUNT}: $1${NORMAL}"
  CURRENT_STEP=$((CURRENT_STEP+1))
}

installOrUpdateApt() {
    logStep "Updating apt package lists"
    sudo apt-get update
}

installOrUpdatePackage() {
    title=$1
    url=$2
    package=$3

    logStep "Installing/Updating $title ($package) - $url"

    if dpkg -s "$package" >/dev/null 2>&1; then
        sudo apt-get install --only-upgrade -y "$package"
    else
        sudo apt-get install -y "$package"
    fi
}

if [ ! -f "${APT_CONFIG_FILE}" ]; then
  echo "${BRIGHT}Could not find the config file ${RED}${APT_CONFIG_FILE}${WHITE} - aborting"
  exit 1
fi

input_file="${APT_CONFIG_FILE}"
STEP_COUNT=$(( $(grep -v '^\s*$' "$input_file" | wc -l) + 1 ))
CURRENT_STEP=1

installOrUpdateApt

while IFS=';' read -r title url package _ || [ -n "$title" ]; do
    [ -z "$title" ] && continue
    installOrUpdatePackage "$title" "$url" "$package"
done < "$input_file"

# logStep "Installing/Updating asdf plugins - ${SCRIPT_DIR}/install-asdf-plugins.sh"
#${SCRIPT_DIR}/install-asdf-plugins.sh
