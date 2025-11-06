#!/bin/sh

SCRIPT_DIR=$(dirname "$0")

for file in `ls ${SCRIPT_DIR}/gitignore/.gitignore*`; do 
    cat $file; 
    printf "\n\n";
done
