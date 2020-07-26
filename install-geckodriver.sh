#!/bin/sh -ex
INSTALL_DIR="/usr/local/bin"

curl -s -L $(curl -sL https://api.github.com/repos/mozilla/geckodriver/releases/latest | jq -r '.assets[].browser_download_url' | grep linux64) | tar -xz
chmod +x geckodriver
mv geckodriver "$INSTALL_DIR"
echo "installed geckodriver binary in $INSTALL_DIR"
