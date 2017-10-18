#!/usr/bin/env bash
#
# Create a weblate.json file for importing all of the language components into Weblate
#

rm weblate_*.json

for d in */
do
    # Ignore the "build" directory
    if [[ "$d" == "build/" ]]
    then
        continue
    fi

    # All components reuse the repo checked out at <DATA_DIR>/vcs/akeebasubs/component_backend for efficiency reasons
    php ../buildfiles/tools/weblate.php -s 1 -e weblate@akeeba.com -w "Translate.Akeeba" -x "weblate://akeebasubs/component_backend" -o weblate_${d%/*}.json -p ${d%/*} -d $d -m
done;

