#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTANTS_FILE="$SCRIPT_DIR/Constants.env"

if [[ ! -f "$CONSTANTS_FILE" ]]; then
    echo "Error: Constants file not found at $CONSTANTS_FILE" >&2
    exit 1
fi

. "$CONSTANTS_FILE"

# Write the current date and time to the log files
echo "" >> $LOGS_PATH_API
echo "" >> $LOGS_PATH_PWA
echo "$(date '+%D %T')" >> $LOGS_PATH_API
echo "$(date '+%D %T')" >> $LOGS_PATH_PWA

# Pull and run the latest version of the API
docker pull loideunical/loide:api  

# Remove existing API container if present
if [[ -n "$(docker ps -a -q -f name=^/api$)" ]]; then
    echo "Stopping existing API container if running."
    if [[ -n "$(docker ps -q -f name=^/api$)" ]]; then
        docker stop api 
    fi
    echo "Removing existing API container."
    docker rm api 
fi

echo "Starting a new API container."
nohup docker run --network host --mount type=bind,source=$CONFIG_PATH_API,target=/app/config,ro --mount type=bind,source=$CONFIG_SSL_PATH_API,target=/app/config/ssl,ro --restart=always --name api loideunical/loide:api >> $LOGS_PATH_API 2>&1 &

# Pull and run the latest version of the PWA
docker pull loideunical/loide:pwa  

# Remove existing PWA container if present
if [[ -n "$(docker ps -a -q -f name=^/pwa$)" ]]; then
    echo "Stopping existing PWA container if running."
    if [[ -n "$(docker ps -q -f name=^/pwa$)" ]]; then
        docker stop pwa 
    fi
    echo "Removing existing PWA container."
    docker rm pwa 
fi

echo "Starting a new PWA container."
nohup docker run --network host --env VITE_LOIDE_API_SERVER=$API_SERVER --mount type=bind,source=$CONFIG_SERVER_PATH_PWA,target=/app/config/server,ro --mount type=bind,source=$CONFIG_SSL_PATH_PWA,target=/app/config/ssl,ro --restart=always --name pwa loideunical/loide:pwa >> $LOGS_PATH_PWA 2>&1 &
