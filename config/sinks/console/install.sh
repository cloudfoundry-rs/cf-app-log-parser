#!/bin/bash

BASE_DIR=$1

# install config
echo "" >> $CONFIG_PATH
echo "" >> $CONFIG_PATH

cat $BASE_DIR/config.toml >> $CONFIG_PATH

# install entrypoint
cp $BASE_DIR/setup.sh /entrypoints/5_sink_console.sh

# export values for validation only
export CONSOLE_TARGET=stdout
export CONSOLE_ENCODING=json