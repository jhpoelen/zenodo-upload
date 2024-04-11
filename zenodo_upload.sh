#!/bin/bash
# Upload big files to Zenodo.
#
# usage: ./zenodo_upload.sh [deposition id] [filename] [--verbose|-v]
#

set -e

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

BUCKET_DATA=$(curl "${ZENODO_ENDPOINT}/api/deposit/depositions/$DEPOSITION?access_token=$ZENODO_TOKEN")
BUCKET=$(echo "$BUCKET_DATA" | jq --raw-output .links.bucket)

if [ "$VERBOSE" -eq 1 ]; then
    echo
    echo "Deposition ID: $DEPOSITION"
    echo "File path: $FILEPATH"
    echo "File name: $FILENAME"
    echo "Bucket URL: $BUCKET"
fi

if [ "$BUCKET" = "null" ]; then
    echo
    echo "Could not find URL for upload. Response from server:"
    echo "$BUCKET_DATA"
    exit 1
fi

if [ "$VERBOSE" -eq 1 ]; then
    echo "Uploading file..."
fi

curl --progress-bar \
    --retry 5 \
    --retry-delay 5 \
    -o /dev/null \
    --upload-file "$FILEPATH" \
    $BUCKET/"$FILENAME"?access_token="$ZENODO_TOKEN"
