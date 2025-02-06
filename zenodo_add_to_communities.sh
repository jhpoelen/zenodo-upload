#!/bin/bash
# Add submitted deposit to communities
#
# usage: ./zenodo_remove_from_communities.sh [deposit id] [metadata filename] [--verbose|-v]
#
# with metadata containing the uuids of the communities that you'd like the deposit to be added to 
#
# {"communities":[{"id":"e61e4c2d-471e-49ef-9e56-794390b01c59"}]}

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

DEPOSITION_ENDPOINT="${ZENODO_ENDPOINT}/api/records/${DEPOSIT}/communities"

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
    --data "@${FILEPATH}" \
    "${DEPOSITION_ENDPOINT}?access_token=${ZENODO_TOKEN}"
