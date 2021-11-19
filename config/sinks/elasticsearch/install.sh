#!/bin/bash

BASE_DIR=$1

# install config
echo "" >> $CONFIG_PATH
echo "" >> $CONFIG_PATH

cat $BASE_DIR/config.toml >> $CONFIG_PATH

# install entrypoint
cp $BASE_DIR/setup.sh /entrypoints/5_sink_elasticsearch.sh

# export values for validation only
export ELASTICSEARCH_ENDPOINT="http://0.0.0.0:9200"
export ELASTICSEARCH_INDEX="vector-%F"
export ELASTICSEARCH_MODE="bulk"