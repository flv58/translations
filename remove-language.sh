#!/usr/bin/env bash
#
# @package    translations
# @copyright  (c) 2010-2017 Akeeba Ltd
# @license    GNU GPLv3 or, at your option, any later version published by the Free Software Foundation
#
# Remove a language from a project
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
NUM_EXISTING_FOLDERS=${#EXISTING_FOLDERS_ARRAY[@]}

if [[ $NUM_EXISTING_FOLDERS -lt 1 ]]
then
    echo "Language $2 does not exist in project $1"

    exit 254
fi

echo "Removing language $2 from project $1"
for d in $EXISTING_FOLDERS
do
    rm -rf $d
done
