#!/bin/bash

if [[ -z "$S3_COMPRESSION" ]];
then
    echo "Using default compression \"gzip\" for the s3 sink"
    export S3_COMPRESSION="gzip"
else
    if [[ $S3_COMPRESSION == "none" || $S3_COMPRESSION == "gzip" ]];
    then
        echo "Using user specified compression $S3_COMPRESSION"
    else
        echo "Specified console compression $S3_COMPRESSION is not allowed"
        exit 1
    fi
fi

if [[ -z "$S3_ENCODING" ]];
then
    echo "Using default encoding \"text\" for the s3 sink"
    export S3_ENCODING="text"
else
    if [[ $S3_ENCODING == "text" || $S3_ENCODING == "ndjson" ]];
    then
        echo "Using user specified encoding $S3_ENCODING"
    else
        echo "Specified s3 encoding $S3_ENCODING is not allowed"
        exit 1
    fi
fi

if [[ ! -z "$S3_ACCESS_KEY"  || ! -z "$S3_SECRET_ACCESS_KEY" ]];
then
    check_env_vars "S3_ACCESS_KEY" "S3_SECRET_ACCESS_KEY"
    echo "Using access key and secret for s3 authentication"

    dasel put string -f $CONFIG_PATH sinks.s3.auth.access_key_id "$S3_ACCESS_KEY"
    dasel put string -f $CONFIG_PATH sinks.s3.auth.secret_access_key "$S3_SECRET_ACCESS_KEY"
else
    echo "No authentication for s3 found"
fi

check_env_vars "S3_BUCKET_NAME" "S3_KEY_PREFIX" "S3_REGION"