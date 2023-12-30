#!/bin/sh

function parseModule() {
    BASE_DIR=$1
    MODULE_DIR=$2
    cd $BASE_DIR/$MODULE_DIR; 

    printf "${BASE_DIR};${MODULE_DIR}\n"
}

function listModules() {
    BASE_DIR=$1
    cd ${BASE_DIR}
    FD_EXECUTABLE=/opt/homebrew/bin/fd
    DIR_LIST=`${FD_EXECUTABLE} '\.git$' --prune -u -t d --exclude '.terraform' --exclude 'node_modules' -x echo {//} | sed 's|\.\/||' | xargs -I {} ${FD_EXECUTABLE} 'build.gradle|package.json|Pipfile|requirements.txt|pom.xml|go.mod'  {} -t f -x echo {//}`
    
    for repo_dir in ${DIR_LIST}; do 
		parseModule ${BASE_DIR} $repo_dir; 
    done
}

PP_CONFIG_DIR=${HOME}/.config/pp
PP_CONFIG_FILE=${PP_CONFIG_DIR}/pp.list 

parseModule ${HOME} .scripts > ${PP_CONFIG_FILE}
listModules ${HOME}/code/personal >> ${PP_CONFIG_FILE}
listModules ${HOME}/code/opensoure >> ${PP_CONFIG_FILE}
listModules ${HOME}/code/work >> ${PP_CONFIG_FILE}
