#!/usr/bin/env bash

# sub to badcop at https://www.twitch.tv/badcop_
# she helped me fix this shitty script

if [ "$1" = "--local" ]; then
  echo "Building source..."
  make build
  sudo cp build/standup /usr/local/bin
  echo "Installed local version of standup!"
  exit 0
fi

owner='stordahl'
repo='standup'
filename='standup'

echo "fetching latest version"
latest_version=$(
    curl -sI https://github.com/$owner/$repo/releases/latest |
    grep -i location |
    sed -e 's|.*tag/||' -e 's|/.*||' -e 's/\r$//'
)

if [ -z "$latest_version" ]; then
    echo "Failed to fetch the latest version."
    exit 1
fi

echo "version: $latest_version"

link="https://github.com/$owner/$repo/releases/download/$latest_version/$filename"

echo "$link"

curl -fsSL "$link" -o "/usr/local/bin/$filename"

chmod +x "/usr/local/bin/$filename"

exit 0
