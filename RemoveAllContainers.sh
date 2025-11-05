#!/bin/bash

if [[ -n "$(docker ps -q)" ]]; then
    ./StopPWA-API.sh
    docker rm -vf $(docker ps -aq)
else
    echo "No containers to remove."
fi
