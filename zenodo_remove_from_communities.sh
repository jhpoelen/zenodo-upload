#!/bin/bash
# Remove submitted deposit from communities
#
# usage: ./zenodo_remove_from_communities.sh [deposit id] [metadata filename] [--verbose|-v]
#
# with metadata containing the uuids of the communities that you'd like the deposit to be removed from
#
# {"communities":[{"id":"23bc63d8-1a49-4a20-9519-fb3a3e78f2b4"}, {"id":"c529f97d-f8cb-4c13-a439-9e36891694c2"}]}

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
    -X DELETE\
    --data "@${FILEPATH}" \
    "${DEPOSITION_ENDPOINT}?access_token=${ZENODO_TOKEN}"
