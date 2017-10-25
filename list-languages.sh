#!/usr/bin/env bash
#
# @package    translations
# @copyright  (c) 2010-2017 Akeeba Ltd
# @license    GNU GPLv3 or, at your option, any later version published by the Free Software Foundation
#
# Lists the languages in a project
#

usage () {
	echo -e "Usage: $0 <project>"
	echo ""
	echo "Example:"
	echo ""
	echo "$0 akeebasubs"

	exit 255
}

if [ $# -lt 2 ]
then
	usage

	exit 255
fi

RAWDIRS=`find $1 -type d -links 2 -not -name "_pages" -printf "%f\n"`
DIRS=( $RAWDIRS )
echo "${RAWDIRS[@]}" | tr ' ' '\n' | sort -u
