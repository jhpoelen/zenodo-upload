#!/bin/bash
# Upload big files to Zenodo.
#
# usage: ./zenodo_upload.sh [-s] <deposition id> <filename> 
# -s ... upload to zenodo sandbox

set -e

SBSTR=""

while getopts "s" opt; do
    case $opt in
	    "s") echo "running in sandbox mode" >&2 
		SBSTR="sandbox."
		;;
	     *) echo "Error: invalid option" >&2
		exit 1
		;;
    esac
done
# reset option index for positional arguments later
shift "$(( OPTIND - 1 ))"


# strip deposition url prefix if provided; see https://github.com/jhpoelen/zenodo-upload/issues/2#issuecomment-797657717
DEPOSITION=$( echo $1 | sed "s+^http[s]*://${SBSTR}zenodo.org/deposit/++g" )
FILEPATH="$2"
FILENAME=$(echo $FILEPATH | sed 's+.*/++g')

BUCKET=$(curl https://${SBSTR}zenodo.org/api/deposit/depositions/"$DEPOSITION"?access_token="$ZENODO_TOKEN" | jq --raw-output .links.bucket)

curl --progress-bar -o /dev/null --upload-file "$FILEPATH" $BUCKET/"$FILENAME"?access_token="$ZENODO_TOKEN"
