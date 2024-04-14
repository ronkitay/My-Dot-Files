#!/bin/sh

SCRIPT_DIR=$(dirname "$0")

function logStep() {
  echo "${BRIGHT}${GREEN}Step ${CURRENT_STEP}/${STEP_COUNT}: $1${NORMAL}"
  let CURRENT_STEP=CURRENT_STEP+1
}

function installFormulae() {
    if [ -f /opt/homebrew/bin/$1 ]; 
    then
        brew upgrade $1;
    else
        brew install $1;
    fi
}

STEP_COUNT=14

let CURRENT_STEP=1

logStep "Installing/Updating Homebrew - https://brew.sh/"
if [ -f /opt/homebrew/bin/brew ]; 
then
    brew update;
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

logStep "Installing/Updating Fuzzy Finder (fzf) - https://github.com/junegunn/fzf"
installFormulae fzf

logStep "Installing/Updating batcat (bat) - https://github.com/sharkdp/bat"
installFormulae bat

logStep "Installing/Updating fd (find replacement) - https://github.com/sharkdp/fd"
installFormulae fd

logStep "Installing/Updating jq (JSON Query)  - https://jqlang.github.io/jq/download/"
installFormulae jq

logStep "Installing/Updating yq (YAML Query)  - https://github.com/mikefarah/yq"
installFormulae yq

logStep "Installing/Updating tree - https://formulae.brew.sh/formula/tree"
installFormulae tree

logStep "Installing/Updating SwitchAudioSource  - https://github.com/deweller/switchaudio-osx"
installFormulae switchaudio-osx

logStep "Installing/Updating asdf - https://asdf-vm.com/guide/getting-started.html"
installFormulae asdf

logStep "Installing/Updating asdf plugins - ${SCRIPT_DIR}/install-asdf-plugins.sh"
${SCRIPT_DIR}/install-asdf-plugins.sh

logStep "Installing/Updating kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#install-with-homebrew-on-macos"
installFormulae kubectl

logStep "Installing/Updating kubectx - https://formulae.brew.sh/formula/kubectx"
installFormulae kubectx

logStep "Installing/Updating helm - https://helm.sh/docs/intro/install/"
installFormulae helm

logStep "Installing/Updating clisso - https://github.com/allcloud-io/clisso"
[[ $(brew tap allcloud-io/tools > /dev/null 2>&1) -ne 0 ]] && brew tap allcloud-io/tools
installFormulae clisso
