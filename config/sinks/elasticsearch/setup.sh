#!/bin/bash

if [[ ! -z "$ELASTICSEARCH_AUTH_ACCESS_KEY_ID" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.auth.access_key_id "$ELASTICSEARCH_AUTH_ACCESS_KEY_ID"
fi

if [[ ! -z "$ELASTICSEARCH_AUTH_SECRET_ACCESS_KEY" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.auth.secret_access_key "$ELASTICSEARCH_AUTH_SECRET_ACCESS_KEY"
fi

if [[ ! -z "$ELASTICSEARCH_AUTH_ASSUME_ROLE" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.auth.assume_role "$ELASTICSEARCH_AUTH_ASSUME_ROLE"
fi

if [[ ! -z "$ELASTICSEARCH_AUTH_CREDENTIALS_FILE" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.auth.credentials_file "$ELASTICSEARCH_AUTH_CREDENTIALS_FILE"
fi

if [[ ! -z "$ELASTICSEARCH_AUTH_PASSWORD" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.auth.password "$ELASTICSEARCH_AUTH_PASSWORD"
fi

if [[ ! -z "$ELASTICSEARCH_AUTH_USER" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.auth.user "$ELASTICSEARCH_AUTH_USER"
fi

if [[ ! -z "$ELASTICSEARCH_AUTH_PROFILE" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.auth.secret_access_key "$ELASTICSEARCH_AUTH_SECRET_ACCESS_KEY"
fi

if [[ ! -z "$ELASTICSEARCH_AUTH_STRATEGY" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.auth.strategy "$ELASTICSEARCH_AUTH_STRATEGY"
fi

if [[ ! -z "$ELASTICSEARCH_AWS_REGION" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.aws.region "$ELASTICSEARCH_AWS_REGION"
fi

if [[ ! -z "$ELASTICSEARCH_PIPELINE" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.pipeline "$ELASTICSEARCH_PIPELINE"
fi

if [[ ! -z "$ELASTICSEARCH_DATA_STREAM_AUTO_ROUTING" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.data_stream.auto_routing "$ELASTICSEARCH_DATA_STREAM_AUTO_ROUTING"
fi

if [[ ! -z "$ELASTICSEARCH_DATA_STREAM_DATASET" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.data_stream.dataset "$ELASTICSEARCH_DATA_STREAM_DATASET"
fi

if [[ ! -z "$ELASTICSEARCH_DATA_STREAM_NAMESPACE" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.data_stream.namespace "$ELASTICSEARCH_DATA_STREAM_NAMESPACE"
fi

if [[ ! -z "$ELASTICSEARCH_DATA_SYNC_FIELDS" ]]; then
    dasel put string -f $CONFIG_PATH sinks.elasticsearch.data_stream.sync_fields "$ELASTICSEARCH_DATA_SYNC_FIELDS"
fi

if [[ ! -z "$ELASTICSEARCH_AUTH_ACCESS_KEY_ID" || ! -z "$ELASTICSEARCH_AUTH_SECRET_ACCESS_KEY" ]]; then
    check_env_vars "ELASTICSEARCH_AUTH_SECRET_ACCESS_KEY" "ELASTICSEARCH_AUTH_ACCESS_KEY_ID"
fi

if [[ ! -z "$ELASTICSEARCH_AUTH_USER" || ! -z "$ELASTICSEARCH_AUTH_PASSWORD" ]]; then
    check_env_vars "ELASTICSEARCH_AUTH_USER" "ELASTICSEARCH_AUTH_PASSWORD"
fi

if [[ ! -z "$ELASTICSEARCH_MODE" ]]; then
    if [[ "$ELASTICSEARCH_MODE" != "bulk" && "$ELASTICSEARCH_MODE" != "data_stream" ]]; then
        echo "ELASTICSEARCH_MODE either needs to be 'bulk' or 'data_stream'"
    fi
else
    echo "Using default ELASTICSEARCH_MODE 'bulk'"
    export ELASTICSEARCH_MODE="bulk"
fi

check_env_vars "ELASTICSEARCH_ENDPOINT" "ELASTICSEARCH_INDEX" "ELASTICSEARCH_MODE"
