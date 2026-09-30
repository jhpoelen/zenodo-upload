#!/bin/bash
# Creates a new version of an existing deposit
#
# usage: ./zenodo_new_version.sh [deposit id] [--verbose|-v]
#
# on success returns deposit id

set -ex

DEPOSIT="$1"

VERBOSE=0
if [ "$2" == "--verbose" ] || [ "$2" == "-v" ]; then
    VERBOSE=1
fi

ZENODO_ENDPOINT=${ZENODO_ENDPOINT:-https://zenodo.org}

DEPOSITION_ENDPOINT="${ZENODO_ENDPOINT}/api/deposit/depositions/${DEPOSIT}/actions/newversion"

if [ "$VERBOSE" -eq 1 ]; then
    echo "Requesting to create a new version for deposit [${DEPOSIT}]..."
fi

curl --progress-bar \
    --retry 5 \
    --retry-delay 5 \
    -H "Content-Type: application/json" \
    -X POST\
    --data "{}"\
    "${DEPOSITION_ENDPOINT}?access_token=${ZENODO_TOKEN}"\
  | jq .id
