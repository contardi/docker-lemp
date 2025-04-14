#!/bin/bash

CURRENTDIR=$(dirname "$0")

echo "importing $CURRENTDIR/functions.sh"
source $CURRENTDIR/functions.sh

usage() {
  echo "Store importer M2 v 2.0
  Usage
  $ shell/m2-create-empty.sh {site-name}
   * site-name: name of the store in m2.local server, e.g. m2.local
  "
}

if [ $# -eq 0 ]; then
  usage
  exit 0
fi

if [ ${0} != "shell/m2-create-empty.sh" ]; then
  echo "You must run the script in the lemp folder"
  exit 0
fi

createDir

cd ${DIR}
echo "Setting up ownership"
sudo chown -R ${USER}: ${DIR}/

verifySshKeys
addHost
copyMagento2Vhost
generateCertificate
createDatabase

installM2

echo "Reloading NGINX"
docker compose restart webserver

setFilePermissions

echo "You can use your store now in https://$HOST/"

