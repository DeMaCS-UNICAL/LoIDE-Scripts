#!/bin/bash

# CONFIG_PATH_API and CONFIG_PATH_PWA are the paths to the configuration folders of the API and PWA, respectively.
# LOGS_PATH_API and LOGS_PATH_PWA are the paths to the log files of the API and PWA, respectively.
# API_SERVER is the IP address of the API server.
BASE_PATH=""
CONFIG_PATH_API="$BASE_PATH/api/config"
LOGS_PATH_API="$BASE_PATH/api/logs/api.log"
CONFIG_SERVER_PATH_PWA="$BASE_PATH/pwa/config/server"
CONFIG_SSL_PATH_PWA="$BASE_PATH/pwa/config/ssl"
LOGS_PATH_PWA="$BASE_PATH/pwa/logs/pwa.log"
API_SERVER=""

# Write the current date and time to the log files
echo "" >> $LOGS_PATH_API
echo "" >> $LOGS_PATH_PWA
echo "$(date '+%D %T')" >> $LOGS_PATH_API
echo "$(date '+%D %T')" >> $LOGS_PATH_PWA

# Pull and run the latest version of the API
docker pull loideunical/loide:api  | head -n 3

# Check if the API container is already running
if [[ -n "$(docker ps -q -f name=api)" ]]; then
    echo "API container is already running. Avoiding to start a new one."
# If not start a new API container
else
    echo "Starting a new API container."
    nohup docker run --network host --mount type=bind,source=$CONFIG_PATH_API,target=/app/config,ro --restart=always --name api loideunical/loide:api >> $LOGS_PATH_API 2>&1 &
fi

# Pull and run the latest version of the PWA
docker pull loideunical/loide:pwa  | head -n 3

# Check if the PWA container is already running
if [[ -n "$(docker ps -q -f name=pwa)" ]]; then
    echo "PWA container is already running. Avoiding to start a new one."
# If not start a new PWA container
else
    echo "Starting a new PWA container."
    nohup docker run --network host --env REACT_APP_LOIDE_API_SERVER=$API_SERVER --mount type=bind,source=$CONFIG_SERVER_PATH_PWA,target=/app/config/server,ro --mount type=bind,source=$CONFIG_SSL_PATH_PWA,target=/app/config/ssl,ro --restart=always --name pwa loideunical/loide:pwa >> $LOGS_PATH_PWA 2>&1 &
fi
