#!/bin/sh

if [[ -z "$CONSOLE_TARGET" ]]; then
    echo "Using default target \"stdout\" for the console sink"
    export CONSOLE_TARGET="stdout"
else
    if [[ $CONSOLE_TARGET == "stdout" || $CONSOLE_TARGET == "stderr" ]]; then
        echo "Using user specified target $CONSOLE_TARGET"
    else
        echo "Specified console target $CONSOLE_TARGET is not allowed"
        exit 1
    fi
fi

if [[ -z "$CONSOLE_ENCODING" ]]; then
    echo "Using default encoding \"json\" for the console sink"
    export CONSOLE_ENCODING="json"
else
    if [[ $CONSOLE_ENCODING == "text" || $CONSOLE_ENCODING == "json" ]]; then
        echo "Using user specified target $CONSOLE_ENCODING"
    else
        echo "Specified console target $CONSOLE_ENCODING is not allowed"
        exit 1
    fi
fi
