#!/usr/bin/env bash
#
# Create the language packages and publish them to S3
#

for d in */
do
    # Ignore the "build" directory
    if [[ "$d" == "build/" ]]
    then
        continue
    fi

    php ../buildfiles/buildlang/buildlang-bare.php $d/build.ini;`pwd`/build.ini;`pwd`/../build.ini `pwd`/$d
done;

