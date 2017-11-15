#!/usr/bin/env bash
#
# @package    translations
# @copyright  (c) 2010-2017 Akeeba Ltd
# @license    GNU GPLv3 or, at your option, any later version published by the Free Software Foundation
#
# Adds a language to a project
#

usage () {
	echo -e "Usage: $0 <project> <language>"
	echo ""
	echo "Example:"
	echo ""
	echo "$0 akeebasubs el-GR"

	exit 255
}

if [ $# -lt 2 ]
then
	usage

	exit 255
fi

EXISTING_FOLDERS=`find $1 -type d -name "$2"`
EXISTING_FOLDERS_ARRAY=( $EXISTING_FOLDERS )

echo "Adding language $2 to project $1"
EN_FOLDERS=`find $1 -type d -name "en-GB"`

for ORIG in $EN_FOLDERS
do
    BASEFOLDER=`dirname $ORIG`
    NEWFOLDER=$BASEFOLDER/$2

    if [ ! -d "$NEWFOLDER" ]
    then
        mkdir $NEWFOLDER
    fi

    # Create empty files for what is missing
    for d in $ORIG/*.ini
    do
        basename=`basename $d`
        NEWFILE=$NEWFOLDER/`echo $basename | sed -e 's/en-GB\./'$2'./'`

        if [ ! -f "$NEWFILE" ]
        then
            touch $NEWFILE
        fi
    done
done
