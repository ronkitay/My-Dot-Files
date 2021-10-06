#!/bin/sh

########################################################################
### Wrapper for calling Beyond Compare for file diffs when using Git ###
########################################################################

# diff is called by git with 7 parameters:
# path old-file old-hex old-mode new-file new-hex new-mode

TEMP_PATH=/tmp/bc-diff-for-git/$RANDOM
TEMP_FILE=${TEMP_PATH}/$(basename $2)

mkdir -p ${TEMP_PATH}
cp $2 ${TEMP_FILE}
/usr/local/bin/bcompare "$TEMP_FILE" "$5" 
