#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTANTS_FILE="$SCRIPT_DIR/Constants.env"

if [[ ! -f "$CONSTANTS_FILE" ]]; then
    echo "Error: Constants file not found at $CONSTANTS_FILE" >&2
    exit 1
fi

. "$CONSTANTS_FILE"

# Write the current date and time to the log files
echo "" >> $LOGS_PATH_ESE
echo "$(date '+%D %T')" >> $LOGS_PATH_ESE

# Pull and run the latest version of the ESE
docker pull loideunical/loide:ese 

# Remove existing ESE container if present
if [[ -n "$(docker ps -a -q -f name=^/ese$)" ]]; then
    echo "Stopping existing ESE container if running."
    if [[ -n "$(docker ps -q -f name=^/ese$)" ]]; then
        docker stop ese 
    fi
    echo "Removing existing ESE container."
    docker rm ese
fi

echo "Starting a new ESE container."
nohup docker run --network host --mount type=bind,source=$CONFIG_PATH_ESE,target=/config_files,ro --mount type=bind,source=$EXECUTABLES_PATH_ESE,target=/executables,ro --privileged=true --restart=always -e PYTHONUNBUFFERED=1 --name ese loideunical/loide:ese >> $LOGS_PATH_ESE 2>&1 &
