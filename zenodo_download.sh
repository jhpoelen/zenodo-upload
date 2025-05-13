#!/bin/bash

# Usage:
# ./zenodo-download.sh [deposition id] [target_filename]

if [ $# -ne 2 ]; then
    echo "Usage: $0 <deposition_id> <target_filename>"
    exit 1
fi

DEPOSITION_ID=$1
TARGET_FILE=$2

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it first."
    exit 1
fi

# Get JSON record
RECORD_URL="https://zenodo.org/api/records/$DEPOSITION_ID"
JSON=$(curl -s "$RECORD_URL")

# Extract download URL for the specified file using jq
FILE_URL=$(echo "$JSON" | jq -r ".files[] | select(.key == \"$TARGET_FILE\") | .links.self")

# Download the file
echo "Downloading $TARGET_FILE from $DEPOSITION_ID..."
curl -# -L --retry 5 --retry-delay 5 -o "$TARGET_FILE" "$FILE_URL"

if [ $? -eq 0 ]; then
    echo "Successfully downloaded $TARGET_FILE"
else
    echo "Failed to download $TARGET_FILE"
fi
