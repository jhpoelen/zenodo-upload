#!/bin/bash
# Deletes all files of a Zenodo deposition.
#
# usage: ./zenodo_upload.sh [deposition id] [filename]
#

set -xe

DEPOSITION=$1
FILEPATH=$2
FILENAME=$(echo $FILEPATH | sed 's+.*/++g')

curl -H "Accept: application/json" -H "Authorization: Bearer $ZENODO_TOKEN" "https://www.zenodo.org/api/deposit/depositions/$DEPOSITION/files" | jq --raw-output .[].id > file_ids.txt

cat file_ids.txt | parallel "echo curl -XDELETE -H \\\"Authorization: Bearer $ZENODO_TOKEN\\\" \\\"https://www.zenodo.org/api/deposit/depositions/$DEPOSITION/files/{1}\\\"" > delete_cmds.sh
