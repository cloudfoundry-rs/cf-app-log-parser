#!/bin/bash

BASE_DIR=$1

# install config
echo "" >>$CONFIG_PATH
echo "" >>$CONFIG_PATH

cat "$BASE_DIR/config.toml" >>$CONFIG_PATH

# install entrypoint
cp "$BASE_DIR/setup.sh" /entrypoints/5_sink_s3.sh

# export values for validation only
export S3_COMPRESSION=gzip
export S3_BUCKET_NAME=example
export S3_KEY_PREFIX="date=%F/"
export S3_REGION="us-east-1"
export S3_ENCODING="text"
