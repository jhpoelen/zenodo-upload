#!/bin/bash
# Upload big files to Zenodo.
#
# usage: ./zenodo_upload.sh [deposition id] [filename] [--verbose|-v]
#

set -xe

VERBOSE=0
if [ "$3" == "--verbose" ] || [ "$3" == "-v" ]; then
    VERBOSE=1
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
    --retry 50 \
    --retry-delay 5 \
    --retry-all-errors \
    -o /dev/null \
    --upload-file "$FILEPATH" \
    $BUCKET/"$FILENAME"?access_token="$ZENODO_TOKEN"
