#!/bin/sh

CONFIG_DIR=${HOME}/.config/ron

ASDF_PLUGIN_CONFIG_FILE=${CONFIG_DIR}/asdf-plugins
ASDF_VERSIONS_CONFIG_FILE=${CONFIG_DIR}/asdf-versions
ASDF_GLOBALS_CONFIG_FILE=${CONFIG_DIR}/asdf-globals

let CURRENT_STEP=1

function logStep() {
  echo "${BRIGHT}${BLUE}asdf plugin setup ${CURRENT_STEP}/${STEP_COUNT}: $1${NORMAL}"
  let CURRENT_STEP=CURRENT_STEP+1
}

function installPlugin() {
  title=$1
  plugin=$2

  let PLUGIN_COUNT=$(asdf plugin list | egrep "^${plugin}$" | wc -l|bc)
  if [ $PLUGIN_COUNT -eq 0 ]; 
  then
    logStep "Installing plugin ${title}"
    asdf plugin add $plugin
  else
    logStep "Updating plugin ${title}"
    asdf plugin update $plugin
  fi
}

function installVersion() {
  plugin=$1
  version=$2

  logStep "Installing/Updating $plugin $version"
  asdf install $plugin $version
} 

function setGlobalVersion() {
  plugin=$1
  version=$2

  logStep "Setting $version as the Global version for $plugin"
  asdf global $plugin $version
} 

if [ ! -f ${ASDF_PLUGIN_CONFIG_FILE} ]; 
then
  echo "${BRIGHT}Could not find the config file ${RED}${ASDF_PLUGIN_CONFIG_FILE}${WHITE} - aborting"
  exit 1
fi

if [ ! -f ${ASDF_VERSIONS_CONFIG_FILE} ]; 
then
  echo "${BRIGHT}Could not find the config file ${RED}${ASDF_VERSIONS_CONFIG_FILE}${WHITE} - aborting"
  exit 1
fi

let STEP_COUNT="$(cat $ASDF_PLUGIN_CONFIG_FILE | egrep -v '^\s+$'| wc -l)+$(cat $ASDF_VERSIONS_CONFIG_FILE | egrep -v '^\s+$'| wc -l)"

if [ -f ${ASDF_GLOBALS_CONFIG_FILE} ]; 
then
  let STEP_COUNT="$(cat $ASDF_GLOBALS_CONFIG_FILE | egrep -v '^\s+$'| wc -l)+${STEP_COUNT}"
fi


while IFS=';' read -r title plugin || [ -n "$title" ]; do
    [ -z "$title" ] && continue
    
    installPlugin "$title" "$plugin"
done < "$ASDF_PLUGIN_CONFIG_FILE"


while IFS=';' read -r plugin version || [ -n "$plugin" ]; do
    [ -z "$plugin" ] && continue
    [ -z "$version" ] && continue
    
    installVersion "$plugin" "$version"
done < "$ASDF_VERSIONS_CONFIG_FILE"

if [ -f ${ASDF_GLOBALS_CONFIG_FILE} ]; 
then
  while IFS=';' read -r plugin version || [ -n "$plugin" ]; do
      [ -z "$plugin" ] && continue
      [ -z "$version" ] && continue
      
      setGlobalVersion "$plugin" "$version"
  done < "$ASDF_GLOBALS_CONFIG_FILE"
fi

# logStep "Installing Java"
# installPlugin java
# asdf global java system
# asdf install java openjdk-21

# logStep "Installing Kotlin"
# installPlugin kotlin
# asdf install kotlin 1.9.23
# asdf global kotlin 1.9.23

# logStep "Installing Python"
# installPlugin python
# asdf install python 3.10.10
# asdf global python 3.10.10

# logStep "Installing NodeJS"
# installPlugin nodejs
# asdf install nodejs 14.21.3
# asdf install nodejs 16.16.0
# asdf install nodejs 20.11.1

# logStep "Installing Golang"
# installPlugin golang
# asdf install golang 1.21.1
# asdf global golang 1.21.1

# logStep "Installing Terraform"
# # addPlugin terraform https://github.com/asdf-community/asdf-hashicorp.git
# addPlugin terraform https://github.com/echo asdf-community/echo asdf-hashicorp.git
# asdf install terraform 0.13.7
# asdf install terraform 1.5.4
# asdf global terraform 0.13.7
