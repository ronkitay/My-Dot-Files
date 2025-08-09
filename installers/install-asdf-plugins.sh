#!/bin/bash

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
  url=$3

  let PLUGIN_COUNT=$(asdf plugin list | egrep "^${plugin}$" | wc -l|bc)
  if [ $PLUGIN_COUNT -eq 0 ]; 
  then
    logStep "Installing plugin ${title}"
    if [ -z "$url" ]; 
    then
      asdf plugin add $plugin
    else
      asdf plugin-add $plugin $url
    fi
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
  asdf set --home $plugin $version
} 

function validateConfiguration() {
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
}

function installPlugins() {
  while IFS=';' read -r title plugin url || [ -n "$title" ]; do
      [ -z "$title" ] && continue
      
      installPlugin "$title" "$plugin" "$url"
  done < "$ASDF_PLUGIN_CONFIG_FILE"
}

function installVersions() {
  while IFS=';' read -r plugin version || [ -n "$plugin" ]; do
    [ -z "$plugin" ] && continue
    [ -z "$version" ] && continue
    
    installVersion "$plugin" "$version"
  done < "$ASDF_VERSIONS_CONFIG_FILE"
}

function setGlobals() {
  if [ -f ${ASDF_GLOBALS_CONFIG_FILE} ]; 
  then
    while IFS=';' read -r plugin version || [ -n "$plugin" ]; do
        [ -z "$plugin" ] && continue
        [ -z "$version" ] && continue
        
        setGlobalVersion "$plugin" "$version"
    done < "$ASDF_GLOBALS_CONFIG_FILE"
  fi
}

validateConfiguration

let STEP_COUNT="$(cat $ASDF_PLUGIN_CONFIG_FILE | egrep -v '^\s+$'| wc -l)+$(cat $ASDF_VERSIONS_CONFIG_FILE | egrep -v '^\s+$'| wc -l)"

if [ -f ${ASDF_GLOBALS_CONFIG_FILE} ]; 
then
  let STEP_COUNT="$(cat $ASDF_GLOBALS_CONFIG_FILE | egrep -v '^\s+$'| wc -l)+${STEP_COUNT}"
fi

installPlugins

installVersions

setGlobals


