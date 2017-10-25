#!/usr/bin/env bash
#
# @package    translations
# @copyright  (c) 2010-2017 Akeeba Ltd
# @license    GNU GPLv3 or, at your option, any later version published by the Free Software Foundation
#
# Create a weblate.json file for importing all of the language components into Weblate
#

# Create the output
rm -rf `pwd`/release/_weblate
mkdir -p `pwd`/release/_weblate

for d in */
do
    # Ignore some internal directories
    if [[ "$d" == "build/" ]] || [[ "$d" == "_pages/" ]] || [[ "$d" == "release/" ]]
    then
        continue
    fi

    # All translation components reuse the repo checked out by the Akeeba Subs translation project, component_backend translation component for efficiency reasons
    php ../buildfiles/tools/weblate.php -s 1 -e weblate@akeeba.com -w "Translate.Akeeba" -x "weblate://akeebasubs/component_backend" -o `pwd`/release/_weblate/${d%/*}.json -p ${d%/*} -d $d -m
done;

