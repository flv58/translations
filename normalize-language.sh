#!/usr/bin/env bash
#
# @package    translations
# @copyright  (c) 2010-2017 Akeeba Ltd
# @license    GNU GPLv3 or, at your option, any later version published by the Free Software Foundation
#
# Normalizes languages in a project
#

usage () {
	echo -e "Usage: $0 <project>"
	echo ""
	echo "Example:"
	echo ""
	echo "$0 akeebasubs"

	exit 255
}

if [ $# -lt 1 ]
then
	usage

	exit 255
fi

echo "Normalizing languages in project $1"

# Find all language folders
EN_FOLDERS=`find $1 -type d -name "en-GB"`
LANGUAGES=( )

for ORIG in $EN_FOLDERS
do
    BASEFOLDER=`dirname $ORIG`
    MOREDIRS=(`find $BASEFOLDER -type d -mindepth 1 -maxdepth 1 ! -name "en-GB" -exec basename \{} \;`)
    LANGUAGES=("${LANGUAGES[@]}" "${MOREDIRS[@]}")
done

# Get unique values only
LANGUAGES=($(echo "${LANGUAGES[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

for LANG in ${LANGUAGES[@]}
do
    ./add-language.sh $1 $LANG
done
