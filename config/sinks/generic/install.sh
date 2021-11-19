#!/bin/bash

mkdir -p "/entrypoints/generic/"

for sink in sinks/*;
do
    sink=${sink#"sinks/"}
    if [[ sink != "generic" ]];
    then
        cp -rv "sinks/$sink" "/entrypoints/generic/"
    else
        echo "Leaving out generic to install itself"
    fi
done

BASE_DIR=$1

cp $BASE_DIR/setup.sh /entrypoints/4_generic.sh