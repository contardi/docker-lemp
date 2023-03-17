#!/bin/bash

CURRENTDIR=$(dirname "$0")
echo "importing $CURRENTDIR/functions.sh"
source $CURRENTDIR/functions.sh

usage() {
  echo "Site creator
  Usage
  $ shell/create-site.sh {site-name}
   * site-name: name of the store on site.local server, e.g. site.local
  "
}

if [ $# -eq 0 ]; then
  usage
  exit 0
fi

if [ ${0} != "shell/create-site.sh" ]; then
  echo "You must run the script in the lemp folder"
  exit 0
fi

HOST=$1
BASEDIR=$(echo ${PWD} | sed -e "s/shell//g")
DIR="${BASEDIR}/var/www/$HOST"
DATABASE=$(echo $HOST | sed -e "s/\./_/g")

MYSQL_HOST=mysql
MYSQL_USER=root
MYSQL_PASSWORD=root

COMPOSER_HOME=/var/www/.composer

createDir

cd ${DIR}
echo "Setting up ownership"
sudo chown -R ${USER}: ${DIR}/

verifySshKeys
copyDefaultSiteVhost
addHost
generateCertificate
createDatabase

echo "Reloading NGINX"
docker compose restart webserver

setFilePermissions

echo "Store created, you can use your site now on https://$HOST/"
