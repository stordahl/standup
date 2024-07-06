#!/usr/bin/env bash

make build
sudo cp build/standup /usr/local/bin
echo "Installed local version of standup"

