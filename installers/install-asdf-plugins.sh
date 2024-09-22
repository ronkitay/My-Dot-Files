#!/bin/sh

STEP_COUNT=6

let CURRENT_STEP=1

function logStep() {
  echo "${BRIGHT}${BLUE}asdf plugin setup ${CURRENT_STEP}/${STEP_COUNT}: $1${NORMAL}"
  let CURRENT_STEP=CURRENT_STEP+1
}

function installPlugin() {
  let PLUGIN_COUNT=$(asdf plugin list | egrep "^${1}$" | wc -l|bc)
  if [ $PLUGIN_COUNT -eq 0 ]; 
  then
    asdf plugin add $1
  else
    asdf plugin update $1
  fi
}

function addPlugin() {
  let PLUGIN_COUNT=$(asdf plugin list | egrep "^${1}$" | wc -l|bc)
  if [ $PLUGIN_COUNT -eq 0 ]; 
  then
    asdf plugin-add $1 $2 $3 $4
  else
    asdf plugin-update $1
  fi
}

logStep "Installing Java"
installPlugin java
asdf global java system
asdf install java openjdk-21

logStep "Installing Kotlin"
installPlugin kotlin
asdf install kotlin 1.9.23
asdf global kotlin 1.9.23

logStep "Installing Python"
installPlugin python
asdf install python 3.10.10
asdf global python 3.10.10

logStep "Installing NodeJS"
installPlugin nodejs
asdf install nodejs 14.21.3
asdf install nodejs 16.16.0
asdf install nodejs 20.11.1

logStep "Installing Golang"
installPlugin golang
asdf install golang 1.21.1
asdf global golang 1.21.1

logStep "Installing Terraform"
# addPlugin terraform https://github.com/asdf-community/asdf-hashicorp.git
addPlugin terraform https://github.com/echo asdf-community/echo asdf-hashicorp.git
asdf install terraform 0.13.7
asdf install terraform 1.5.4
asdf global terraform 0.13.7
