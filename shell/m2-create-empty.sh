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

HOST=$1
BASEDIR=$(echo ${PWD} | sed -e "s/shell//g")
DIR="${BASEDIR}/var/www/$HOST"
DATABASE=$(echo $HOST | sed -e "s/\./_/g")

MAGENTO_BASE_DIR=/var/www/$HOST/
MAGENTO_LANGUAGE=pt_BR
MAGENTO_TIMEZONE=America/Sao_Paulo
MAGENTO_DEFAULT_CURRENCY=BRL
MAGENTO_URL=https://$HOST
MAGENTO_BACKEND_FRONTNAME=painel
MAGENTO_USE_SECURE=1
MAGENTO_BASE_URL_SECURE=https://$HOST
MAGENTO_USE_SECURE_ADMIN=1

MYSQL_HOST=mysql
MYSQL_USER=root
MYSQL_PASSWORD=root

SEARCH_ENGINE='elasticsearch7'
ELASTICSEARCH_HOSTNAME='opensearch'
ELASTICSEARCH_PREFIX=$(echo $HOST | sed -e "s/\.//g")

AMQP_HOST=rabbitmq
AMQP_USER=rabbitmq
AMQP_PASS=rabbitmq
AMQP_PORT=5672
AMQP_VIRTUALHOST=/

COMPOSER_HOME=/var/www/.composer
STORE_NAME="M2 Biz Pro"
STORE_EMAIL=admin@$HOST

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

