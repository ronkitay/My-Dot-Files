#/bin/sh

cd $(dirname $0)
BASE_DIR="$(pwd)"

mkdir -p ${HOME}/.config

if [[ -L "${HOME}/.config/bat" ]]; 
then
    echo "Bat - Already configured"
else
    ln -s  ${BASE_DIR}/bat_configurations ${HOME}/.config/bat
    echo "Bat - Done"
fi
