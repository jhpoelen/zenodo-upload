#!/bin/bash
# Deletes all files of a Zenodo deposition.
#
# usage: ./zenodo_delete_all.sh [deposition id] 
#

set -e

# strip deposition url prefix if provided; see https://github.com/jhpoelen/zenodo-upload/issues/2#issuecomment-797657717
DEPOSITION=$( echo $1 | sed 's+^http[s]*://zenodo.org/deposit/++g' )
FILEPATH=$2
FILENAME=$(echo $FILEPATH | sed 's+.*/++g')

curl -H @<(echo -e "Accept: application/json\nAuthorization: Bearer $ZENODO_TOKEN") "https://www.zenodo.org/api/deposit/depositions/$DEPOSITION/files" | jq --raw-output .[].id > file_ids.txt

cat file_ids.txt | parallel "echo curl -XDELETE -H \\\"Authorization: Bearer $ZENODO_TOKEN\\\" \\\"https://www.zenodo.org/api/deposit/depositions/$DEPOSITION/files/{1}\\\"" > delete_cmds.sh
