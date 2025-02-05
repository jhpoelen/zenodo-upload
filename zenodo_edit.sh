#!/bin/bash
# Unlock submitted deposit for metadata editing
#
# usage: ./zenodo_edit.sh [deposit id] [--verbose|-v]
#

set -ex

VERBOSE=0
if [ "$3" == "--verbose" ] || [ "$3" == "-v" ]; then
    VERBOSE=1
fi

DEPOSIT="$1"
FILEPATH="$2"
FILENAME=$(echo $FILEPATH | sed 's+.*/++g')
FILENAME=${FILENAME// /%20}
ZENODO_ENDPOINT=${ZENODO_ENDPOINT:-https://zenodo.org}

DEPOSITION_ENDPOINT="${ZENODO_ENDPOINT}/api/deposit/depositions/${DEPOSIT}"

if [ "$VERBOSE" -eq 1 ]; then
    echo "Deposition ID: ${DEPOSITION}"
    echo "File path: ${FILEPATH}"
    echo "File name: ${FILENAME}"
    echo "Requesting to update deposition..."
fi

curl --progress-bar \
    --retry 5 \
    --retry-delay 5 \
    -H "Content-Type: application/json" \
    -X POST\
    "${DEPOSITION_ENDPOINT}/actions/edit?access_token=${ZENODO_TOKEN}"
