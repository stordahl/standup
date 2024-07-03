#!/usr/bin/env bash

make build
sudo cp build/app /usr/local/bin
echo "Installed local version of app"

