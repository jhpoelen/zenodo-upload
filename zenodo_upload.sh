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

# Test if ZENODO_TOKEN is defined

if [ -z "$ZENODO_TOKEN " ]; then
    echo "Please use the ZENODO_TOKEN environment variable to set your Zenodo API token."
    echo  "You can create a new token at https://zenodo.org/account/settings/applications/tokens/new/"
    exit 2
fi

# test if jq is installed

if ! command -v jq &> /dev/null; then
    echo "jq could not be found. Please install jq to run this script."
    exit 2
fi

# Test if the file provided is actually a file

if [ ! -f "$2" ]; then
    echo "The file $2 does not exist."
    exit 2
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
