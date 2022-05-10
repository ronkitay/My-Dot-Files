#/bin/sh

function link_it() {
    NAME=$1
    TARGET=$2
    SOURCE=$3

    if [[ -L "${TARGET}" ]]; 
    then
        echo "${NAME} - Already configured"
    else
        ln -s  ${SOURCE} ${TARGET}
        echo "${NAME} - Done"
    fi
}

cd $(dirname $0)
BASE_DIR="$(pwd)"
link_it 'Aliases' "${HOME}/.aliases" "${BASE_DIR}/.aliases"

cd $(dirname $0)/.config
BASE_DIR="$(pwd)"

mkdir -p ${HOME}/.config

link_it 'Bat' "${HOME}/.config/bat" "${BASE_DIR}/bat_configurations"
link_it 'Bind Key' "${HOME}/.bindkey.settings" "${BASE_DIR}/.bindkey.settings"
link_it 'FZF Setting' "${HOME}/.fzf.settings" "${BASE_DIR}/.bindkey.settings"
link_it 'FZF Setting' "${HOME}/.fzf.settings" "${BASE_DIR}/.bindkey.settings"
link_it 'Input RC' "${HOME}/.inputrc" "${BASE_DIR}/.inputrc"
link_it 'VIM RC' "${HOME}/.vimrc" "${BASE_DIR}/.vimrc"
link_it 'ZSH RC' "${HOME}/.zshrc" "${BASE_DIR}/.zshrc"
link_it 'P10K Configuration' "${HOME}/.p10k.zsh" "${BASE_DIR}/.p10k.zsh"
link_it 'My Docker Images Release' "${HOME}/.my-docker-images.release" "${HOME}/Personal/docker-images/release"
