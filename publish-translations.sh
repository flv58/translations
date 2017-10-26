#!/usr/bin/env bash
#
# @package    translations
# @copyright  (c) 2010-2017 Akeeba Ltd
# @license    GNU GPLv3 or, at your option, any later version published by the Free Software Foundation
#
# Create the language packages and publish them to S3
#

# Make sure BuildFiles is up-to-date
pushd ../buildfiles
git pull --all
composer install
popd

# Loop all directories
for d in */
do
    # Ignore some internal directories
    if [[ "$d" == "build/" ]] || [[ "$d" == "_pages/" ]] || [[ "$d" == "release/" ]]
    then
        continue
    fi

    # Create the output folder for this project
    rm -rf `pwd`/release/$d
    mkdir -p `pwd`/release/$d

    # Call the buildfiles script from the relevant repository
    php ../buildfiles/tools/build-language.php -t `pwd`/$d -o `pwd`/release/$d -d $@
done;
