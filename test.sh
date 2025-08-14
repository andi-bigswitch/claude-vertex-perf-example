#!/bin/bash
set -e -u -o pipefail

status() {
    echo
    echo "================================================================================"
    echo "$@"
    echo "================================================================================"
    echo
}

trace() {
    echo "$ $*"
    eval "$*"
}


status "SETUP 1. Log in with gcloud auth **application-default** login (needed so claude code works at all)"
trace gcloud auth application-default login

status "SETUP 2. Set application-default quota project (unclear if needed)"
trace gcloud auth application-default set-quota-project ${VERTEX_PROJECT_ID}

status "TEST 1: run claude code, works but slow"
trace time CLAUDE_CODE_USE_VERTEX=1 CLOUD_ML_REGION=us-east5 ANTHROPIC_VERTEX_PROJECT_ID=${VERTEX_PROJECT_ID} claude --verbose --output-format stream-json -p 'are you there'

if [ -z "${SKIP_GCLOUD_AUTH_LOGIN:-}" ]; then
    status "SETUP 3: Login in with gcloud auth login"
    trace gcloud auth login
else
    status "SETUP 3: Skipping gcloud auth login (SKIP_GCLOUD_AUTH_LOGIN is set)"
fi

if [ -z "${SKIP_GCLOUD_CONFIG_SET_PROJECT:-}" ]; then
    status "SETUP 4: Set gcloud project"
    trace gcloud config set project ${VERTEX_PROJECT_ID}
else
    status "SETUP 4: Skipping gcloud config set project (SKIP_GCLOUD_CONFIG_SET_PROJECT is set)"
fi

status "TEST 2: run claude code, now fast"
trace time CLAUDE_CODE_USE_VERTEX=1 CLOUD_ML_REGION=us-east5 ANTHROPIC_VERTEX_PROJECT_ID=${VERTEX_PROJECT_ID} claude --verbose --output-format stream-json -p 'are you there'

