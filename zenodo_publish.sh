#!/bin/bash
# Creates a new, empty deposit
#
# usage: ./zenodo_create.sh [--verbose|-v]
#
# on success returns deposit id

set -ex

VERBOSE=0
if [ "$1" == "--verbose" ] || [ "$1" == "-v" ]; then
    VERBOSE=1
fi

ZENODO_ENDPOINT=${ZENODO_ENDPOINT-:https://zenodo.org}

DEPOSITION_ENDPOINT="${ZENODO_ENDPOINT}/api/deposit/depositions"

if [ "$VERBOSE" -eq 1 ]; then
    echo "Requesting to create empty deposition..."
fi

curl --progress-bar \
    --retry 5 \
    --retry-delay 5 \
    -H "Content-Type: application/json" \
    -X POST\
    --data "{}"\
    "${DEPOSITION_ENDPOINT}?access_token=${ZENODO_TOKEN}"\
  | jq .id
