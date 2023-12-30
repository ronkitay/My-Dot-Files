#/bin/sh

function link_it() {
    NAME=$1
    TARGET=$2
    SOURCE=$3

    if [[ ! -e "${SOURCE}" ]]; then
       echo "[${NAME}] does not exist at [${SOURCE}] - skipping"
    else
        if [[ -L "${TARGET}" ]];
        then
            echo "${NAME} - Already configured"
        else
            ln -s  ${SOURCE} ${TARGET}
            echo "${NAME} - Done"
        fi
    fi
}

cd $(dirname $0)
BASE_DIR="$(pwd)"
link_it 'Aliases' "${HOME}/.aliases" "${BASE_DIR}/.aliases"

link_it 'Key ReMapping' "${HOME}/Library/LaunchAgents/com.local.KeyRemapping.plist" "${BASE_DIR}/MacSettings/Library/LaunchAgents/com.local.KeyRemapping.plist"
launchctl load ~/Library/LaunchAgents/com.local.KeyRemapping.plist
launchctl start com.local.KeyRemapping


cd $(dirname $0)/.config
BASE_DIR="$(pwd)"

mkdir -p ${HOME}/.config

link_it 'Bat' "${HOME}/.config/bat" "${BASE_DIR}/bat_configurations"
link_it 'Bind Key' "${HOME}/.bindkey.settings" "${BASE_DIR}/.bindkey.settings"
link_it 'FZF Setting' "${HOME}/.fzf.settings" "${BASE_DIR}/.fzf.settings"
link_it 'MAN Setting' "${HOME}/.man.settings" "${BASE_DIR}/.man.settings"
link_it 'Input RC' "${HOME}/.inputrc" "${BASE_DIR}/.inputrc"
link_it 'VIM RC' "${HOME}/.vimrc" "${BASE_DIR}/.vimrc"
link_it 'ZSH RC' "${HOME}/.zshrc" "${BASE_DIR}/.zshrc"
link_it 'PSQL RC' "${HOME}/.psqlrc" "${BASE_DIR}/.psqlrc"
link_it 'P10K Configuration' "${HOME}/.p10k.zsh" "${BASE_DIR}/.p10k.zsh"
link_it 'My Docker Images Release' "${HOME}/.my-docker-images.release" "${HOME}/code/personal/docker-images/release"



