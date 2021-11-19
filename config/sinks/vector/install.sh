#!/bin/bash

BASE_DIR=$1

# install config
echo "" >> $CONFIG_PATH
echo "" >> $CONFIG_PATH

cat $BASE_DIR/config.toml >> $CONFIG_PATH

# install entrypoint
cp $BASE_DIR/setup.sh /entrypoints/5_sink_vector.sh

# export values for validation only
export VECTOR_VERSION=2
export VECTOR_ADDRESS="custom-vector:9200"