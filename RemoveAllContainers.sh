#!/bin/bash

targets=(api pwa ese)
removed_any=false

for name in "${targets[@]}"; do
    if [[ -n "$(docker ps -a -q -f name=^/${name}$)" ]]; then
        removed_any=true
        if [[ -n "$(docker ps -q -f name=^/${name}$)" ]]; then
            echo "Stopping $name container."
            docker stop "$name"
        fi
        echo "Removing $name container."
        docker rm -vf "$name"
    fi
done

if [[ "$removed_any" = false ]]; then
    echo "No api, pwa, or ese containers to remove."
fi
