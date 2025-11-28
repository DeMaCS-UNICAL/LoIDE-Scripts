#!/bin/bash

#CONFIG_PATH_ESE is the path to the configuration folder of the ESE.
#LOGS_PATH_ESE is the path to the log file of the ESE.
BASE_PATH=""
CONFIG_PATH_ESE="$BASE_PATH/ese/config_files"
EXECUTABLES_PATH_ESE="$BASE_PATH/ese/executables"
LOGS_PATH_ESE="$BASE_PATH/ese/logs/ese.log"

# Write the current date and time to the log files
echo "" >> $LOGS_PATH_ESE
echo "$(date '+%D %T')" >> $LOGS_PATH_ESE

# Pull and run the latest version of the ESE
docker pull loideunical/loide:ese | head -n 3

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
