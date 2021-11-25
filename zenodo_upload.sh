#!/bin/bash
# Upload big files to Zenodo.
#
# usage: ./zenodo_upload.sh [deposition id] [filename]
#

set -e

# strip deposition url prefix if provided; see https://github.com/jhpoelen/zenodo-upload/issues/2#issuecomment-797657717
DEPOSITION=$( echo $1 | sed 's+^http[s]*://zenodo.org/deposit/++g' )
FILEPATH="$2"
FILENAME=$(echo $FILEPATH | sed 's+.*/++g')

BUCKET=$(curl https://zenodo.org/api/deposit/depositions/"$DEPOSITION"?access_token="$ZENODO_TOKEN" | jq --raw-output .links.bucket)

curl --progress-bar -o /dev/null --upload-file "$FILEPATH" $BUCKET/"$FILENAME"?access_token="$ZENODO_TOKEN"
