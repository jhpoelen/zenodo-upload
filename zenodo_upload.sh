#!/bin/bash
# Upload big files to Zenodo.
#
# usage: ./zenodo_upload.sh [deposition id] [filename] [--verbose|-v]
#

set -e

VERBOSE=0
if [ "$3" == "--verbose" ] || [ "$3" == "-v" ]; then
    set -x
    VERBOSE=1
fi

if [ $# -lt 2 ]; then
    echo "Usage: $0 [deposition id] [filename] [--verbose|-v]"
    exit 1
fi

if [ -z "$ZENODO_TOKEN" ]; then
    echo "The ZENODO_TOKEN variable needs to be set and not empty."
    exit 1
fi

# strip deposition url prefix if provided; see https://github.com/jhpoelen/zenodo-upload/issues/2#issuecomment-797657717
DEPOSITION=$( echo $1 | sed 's+^http[s]*://zenodo.org/deposit/++g' )
FILEPATH="$2"
FILENAME=$(echo $FILEPATH | sed 's+.*/++g')
FILENAME=${FILENAME// /%20}
ZENODO_ENDPOINT=${ZENODO_ENDPOINT:-https://zenodo.org}

BUCKET=$(curl ${ZENODO_ENDPOINT}/api/deposit/depositions/"$DEPOSITION"?access_token="$ZENODO_TOKEN" | jq --raw-output .links.bucket)

if [ "$VERBOSE" -eq 1 ]; then
    echo "Deposition ID: $DEPOSITION"
    echo "File path: $FILEPATH"
    echo "File name: $FILENAME"
    echo "Bucket URL: $BUCKET"
    echo "Uploading file..."
fi

curl --progress-bar \
    --retry 5 \
    --retry-delay 5 \
    -o /dev/null \
    --upload-file "$FILEPATH" \
    $BUCKET/"$FILENAME"?access_token="$ZENODO_TOKEN"
