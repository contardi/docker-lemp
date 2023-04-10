#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Create Mkcert Script
Usage
$ shell/create-ssl.sh {hostname}

e.g. shell/create-ssl.sh biz4.local"
    exit 0
fi

CURRENTDIR=$(dirname "$0")
echo "importing $CURRENTDIR/functions.sh"
source $CURRENTDIR/functions.sh

if [  -n "$(uname -a | grep Ubuntu)" ]; then
  echo "Verifying mkcert in Ubuntu OS"
  if [ ! $(command -v mkcert) >/dev/null  ]; then
    installMkCert
  fi
fi

generateSignedCertificate

# Fallback if not works signed certificate
generateUnsignedCertificate

echo "Restarting nginx"
docker compose restart webserver

echo "Verifying nginx"
docker compose ps webserver

echo "DONE, maybe it'll be necessary restart your browser"
