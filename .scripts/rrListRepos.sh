#!/bin/sh

function parseRepo() {
    BASE_DIR=$1
    REPO_DIR=$2
    cd $BASE_DIR/$REPO_DIR; 

    GITURL=$(git remote -v | grep fetch | awk '{print $2}' )

    URL=$(gitUrlToHttp ${GITURL})

    TYPE="unknown"

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

function gitUrlToHttp() {
    printf "$1" | sed 's|git@gitlab.eng.qwilt.com:|https://gitlab.eng.qwilt.com/|' | sed 's|git@gitlab.com:|https://gitlab.com/|' | sed 's|git@github.com:|https://github.com/|' | sed 's|\.git||'
}

function parseArchive() {
    BASE_DIR=$1
    ARCHIVE=$2

    GITURL=$(cat ${BASE_DIR}/${ARCHIVE} | head -n 1 | awk '{print $2}')

    URL=$(gitUrlToHttp ${GITURL})

    printf "${BASE_DIR};${ARCHIVE};${URL};archive\n"
}

function listRepos() {
    BASE_DIR=$1
    cd ${BASE_DIR}
    DIR_LIST=`/opt/homebrew/bin/fd '\.git$' --prune -u -t d --exclude '.terraform' --exclude 'node_modules' -x echo {//} | sed 's|\.\/||'`
    ARCHIVE_LIST=`/opt/homebrew/bin/fd '\.git$' --prune -u -t f`
    
    for repo_dir in ${DIR_LIST}; do 
		parseRepo ${BASE_DIR} $repo_dir; 
    done
    
    for archive in ${ARCHIVE_LIST}; do
        parseArchive ${BASE_DIR} $archive
    done

    TEMP_PARENT_DIR=$(mktemp)
    PARENT_DIRS=$DIR_LIST
    while [[ $(for dir in $PARENT_DIRS; do echo 1; done | wc -l) -gt 0 ]]; 
    do
        PARENT_DIRS=$(for dir in $PARENT_DIRS; do dirname $dir; done | sort -u | grep -v '^\.$')

        for dir in $PARENT_DIRS; 
        do 
            echo "${BASE_DIR};${dir};-;dir" >> ${TEMP_PARENT_DIR}
        done
    done
    echo "$(dirname ${BASE_DIR});$(basename ${BASE_DIR});-;dir" >> ${TEMP_PARENT_DIR}

    cat ${TEMP_PARENT_DIR} | sort -u
    rm ${TEMP_PARENT_DIR}
}

RR_CONFIG_DIR=${HOME}/.config/rr
RR_CONFIG_FILE=${RR_CONFIG_DIR}/rr.list 

parseRepo ${HOME} .scripts > ${RR_CONFIG_FILE}
listRepos ${HOME}/Personal >> ${RR_CONFIG_FILE}
listRepos ${HOME}/work >> ${RR_CONFIG_FILE}
