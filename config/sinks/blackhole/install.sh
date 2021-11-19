#!/bin/bash

BASE_DIR=$1

# install config
echo "" >>$CONFIG_PATH
echo "" >>$CONFIG_PATH

cat "$BASE_DIR/config.toml" >>$CONFIG_PATH
