#! /bin/bash

usage() {
echo "Usage
All you need is the site name

$ remove_store.sh {site}
* site: The name of the store that will be removed.
"
}


if [ $# -eq 0 ]; then
  usage
  exit 0
fi

if [ ${0} != "shell/remove-site.sh" ]; then
  echo "You must run the script in the lemp folder"
  exit 0
fi

PARAM=$1
STORE=$(echo ${PARAM} | sed -e "s/\.local//g")
BASEDIR=$(echo ${PWD} | sed -e "s/shell//g")
DIR="${BASEDIR}/var/www/${STORE}.local"

echo "Verifying ${DIR}..."
if [ -d "${DIR}" ]; then
	echo "Removing folders with store files..."
	sudo rm -rf ${DIR}
fi

echo "Please remove the registry from the virtual host!"
sudo sed -i "s/127\.0\.0\.1 ${STORE}\.local//g" /etc/hosts

echo "Removing store configuration files on the server..."
sudo rm ${BASEDIR}/nginx/conf.d/${STORE}.*.conf

echo "Removing certificates..."
sudo rm ${BASEDIR}/nginx/certificates/${STORE}*.crt
sudo rm ${BASEDIR}/nginx/certificates/${STORE}*.key

echo "Deleting database..."
docker compose exec mysql mysql -h 127.0.0.1 -u root -proot -e "DROP DATABASE IF EXISTS ${STORE}_local;"

echo "Done!"