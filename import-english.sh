#!/usr/bin/env bash

MYFOLDERS=`find $(pwd) -mindepth 1 -maxdepth 1 -type d`

for d in $MYFOLDERS
do
    # Get the repo folder by the same name one level up...
    PARENT_FOLDER=`realpath ..`/`basename $d`
    # ...and its translations subdirectory
    PARENT_TRANSLATIONS=$PARENT_FOLDER/translations

    # If either folder does not exist there is no such repo
    [[ ! -d $PARENT_FOLDER ]] && continue
    [[ ! -d $PARENT_TRANSLATIONS ]] && continue

    echo Importing English strings from $PARENT_FOLDER
    rsync -av $PARENT_TRANSLATIONS/* $d
done
