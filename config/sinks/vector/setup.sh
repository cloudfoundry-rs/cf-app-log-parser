#!/bin/bash

if [[ -z "$VECTOR_VERSION" ]]; then
    echo "Using vector version 1"
    export VECTOR_VERSION=1
else
    echo "Using user provided vector version $VECTOR_VERSION"
fi

check_env_vars "VECTOR_ADDRESS"
