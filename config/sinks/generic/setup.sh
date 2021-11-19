#!/bin/bash

does_sink_exist() {
    arg=$1

    AVAILABLE_SINKS=""

    for sink in /entrypoints/generic/*;
    do
        sink=${sink#"/entrypoints/generic/"}
        if [[ -z "$AVAILABLE_SINKS" ]];
        then
            AVAILABLE_SINKS=$sink
        else
            AVAILABLE_SINKS="$AVAILABLE_SINKS|$sink"
        fi
    done

    if [[ ! "$arg" =~ ^\($AVAILABLE_SINKS\)$ ]]; then
        echo "Couldn't find sink $1" && exit 1
    fi
}

install_sink () {
    arg=$1

    does_sink_exist $1

    echo "Installing sink \"$1\""
    . "/entrypoints/generic/$1/install.sh" "/entrypoints/generic/$1/"
}
PRE_FILES=$(ls /entrypoints/*.sh)

IFS=','

SINK_COUNT=$(set -f -- $INCLUDED_SINKS; echo $#)

echo "Fount $SINK_COUNT sinks to install by generic sink"

for sink_to_check in $INCLUDED_SINKS;
do
    does_sink_exist $sink_to_check

    if [[ $sink_to_check == "generic" ]];
    then
        echo "You are not allowed to install the generic sink using the generic sink"
        exit 1
    fi
done

for sink_to_install in $INCLUDED_SINKS;
do
    install_sink $sink_to_install
done

PORT=8080 vector validate $CONFIG_PATH --no-environment --deny-warnings

unset IFS

POST_FILES=$(ls /entrypoints/*.sh)

for i in $POST_FILES;do
    NEW_FILE=1
    for j in $PRE_FILES;do
        if [[ "$i" == "$j" ]];then
            NEW_FILE=0
        fi
    done
    
    if [[ $NEW_FILE == 1 ]];
    then
        echo "Running $i"
        . "$i"
    fi
done