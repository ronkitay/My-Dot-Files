#!/bin/sh

function parseRepo() {
    BASE_DIR=$1
    REPO_DIR=$2
    cd $BASE_DIR/$REPO_DIR; 

    URL=$(git remote -v | grep fetch | awk '{print $2}' | sed 's|git@gitlab.eng.qwilt.com:|https://gitlab.eng.qwilt.com/|' | sed 's|git@gitlab.com:|https://gitlab.com/|' | sed 's|git@github.com:|https://github.com/|' | sed 's|\.git||')
    
    TYPE="github"

    if [[ "${URL}" = *github* ]]; then
        TYPE="github"
    fi
    if [[ "${URL}" = *gitlab* ]]; then
        TYPE="gitlab"
    fi

    # if [[ "${URL}" = *lambda* ]]; then
    #     TYPE="lambda"
    # fi
    # if [[ "${URL}" = *service* ]]; then
    #     TYPE="microservice"
    # fi
    printf "${BASE_DIR};${REPO_DIR};${URL};${TYPE}\n"
}

function listRepos() {
    BASE_DIR=$1
    cd ${BASE_DIR}
    DIR_LIST=`/opt/homebrew/bin/fd '.git$' --prune -u -t d --exclude '.terraform' --exclude 'node_modules' -x echo {//} | sed 's|\.\/||'`
    for repo_dir in ${DIR_LIST}; do 
		parseRepo ${BASE_DIR} $repo_dir; 
    done
}

RR_CONFIG_DIR=${HOME}/.config/rr
RR_CONFIG_FILE=${RR_CONFIG_DIR}/rr.list 

parseRepo ${HOME} .scripts > ${RR_CONFIG_FILE}
listRepos ${HOME}/Personal >> ${RR_CONFIG_FILE}
listRepos ${HOME}/work >> ${RR_CONFIG_FILE}
