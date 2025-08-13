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

status "SETUP 3: Login in with gcloud auth login"
trace gcloud auth login

status "SETUP 4: Set gcloud project"
trace gcloud config set project ${VERTEX_PROJECT_ID}

status "TEST 2: run claude code, now fast"
trace time CLAUDE_CODE_USE_VERTEX=1 CLOUD_ML_REGION=us-east5 ANTHROPIC_VERTEX_PROJECT_ID=${VERTEX_PROJECT_ID} claude --verbose --output-format stream-json -p 'are you there'

