#!/usr/bin/env bash

TARGET_REPO=/var/www/boot
REPOS=`find $(pwd) -mindepth 1 -maxdepth 1 -type d`

for d in $REPOS
do
    PARENT_REPO=`pwd`/../$(basename $d)
    [[ -d $PARENT_REPO ]] || continue

    BACKEND_FILES=`find $d/component/backend $d/modules/admin $d/plugins -type f -name "el-GR.*.ini" 2>/dev/null`

    for f in $BACKEND_FILES
    do
        TARGET_FILE=$TARGET_REPO/administrator/language/el-GR/`basename $f`
        [[ -L $TARGET_FILE ]] && rm $TARGET_FILE
        [[ -f $TARGET_FILE ]] && rm $TARGET_FILE
        ln -s $f $TARGET_FILE
    done

    FRONTEND_FILES=`find $d/component/frontend $d/modules/site -type f -name "el-GR.*.ini" 2>/dev/null`

    for f in $FRONTEND_FILES
    do
        TARGET_FILE=$TARGET_REPO/language/el-GR/`basename $f`
        [[ -L $TARGET_FILE ]] && rm $TARGET_FILE
        [[ -f $TARGET_FILE ]] && rm $TARGET_FILE
        ln -s $f $TARGET_FILE
    done
done