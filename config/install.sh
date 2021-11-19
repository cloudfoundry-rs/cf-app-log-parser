#!/bin/sh

set -e

count_items () (
  IFS=','
  set -f
  set -- $1
  echo $#
)

does_sink_exist() {
    arg=$1

    AVAILABLE_SINKS=""

    for sink in sinks/*;
    do
        sink=${sink#"sinks/"}
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
    . "sinks/$1/install.sh" "sinks/$1/"
}

IFS=','

SINK_COUNT=$(set -f -- $INCLUDED_SINKS; echo $#)

echo "Fount $SINK_COUNT sinks to install"

for sink_to_check in $INCLUDED_SINKS;
do
    does_sink_exist $sink_to_check

    if [[ $sink_to_check == "generic" && $SINK_COUNT -gt 1 ]];
    then
        echo "You are not allowed to install the generic sink alongside others using this script"
        exit 1
    fi
done

for sink_to_install in $INCLUDED_SINKS;
do
    install_sink $sink_to_install
done

if [[ $SINK_COUNT -gt 0 && $INCLUDED_SINKS != "generic" ]];
then
    PORT=8080 vector validate $CONFIG_PATH --no-environment --deny-warnings
fi