#!/bin/sh

set -e

env() {
    arg=$1
    shift
    eval "echo \$$arg"
}

check_env_vars () {
    NAMES=""
    for name; do
        if [ -z "$(env $name)" ];
        then
            if [ ! -z "$NAMES" ];
            then
                NAMES="$NAMES, \"$name\""
            else
                NAMES="\"$name\""
            fi
        fi
    done

    if [ ! -z "$NAMES" ];
    then
        echo "Environemnt variable(s) $NAMES should not be empty"
        exit 1
    fi
}

ENTRYPOINT_FILES_COUNT=$(ls /entrypoints/*.sh 2>/dev/null | wc -l)

echo "Found $ENTRYPOINT_FILES_COUNT entrypoint files"

if [ $ENTRYPOINT_FILES_COUNT -gt 0 ];
then
    for entrypoint_file in `ls /entrypoints/*.sh`
    do
        echo "Running $entrypoint_file"
        . "$entrypoint_file"
    done
fi

check_env_vars "PORT" "INGEST_AUTH_STRATEGY"

if [ "$INGEST_AUTH_STRATEGY" == "basic" ];
then
    echo "Using basic authentication"
    if [ -z "$(env INGEST_AUTH_SERVICE_NAME)" ];
    then
        check_env_vars "INGEST_AUTH_PASSWORD" "INGEST_AUTH_USERNAME"
    else
        check_env_vars "INGEST_AUTH_SERVICE_NAME"
        # TODO extract username and password
    fi
else
if [ -z "$(env INGEST_AUTH_SERVICE_NAME)" ];
    echo "Using bearer authentication"
    then
        check_env_vars "INGEST_AUTH_TOKEN"
    else
        check_env_vars "INGEST_AUTH_SERVICE_NAME"
        # TODO extract token
    fi
fi

/usr/local/bin/vector