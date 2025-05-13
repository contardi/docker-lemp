#!/bin/bash

usage() {
  echo "Store importer M2 v 2.0
  Usage
  $ bin/m2-clear-processed.sh {destination}
   * destination: folder and host to be cleared, e.g. magento2.local
  "
}

if [ $# -eq 0 ]; then
  usage
  exit 0
fi

if [ ${0} != "bin/m2-clear-processed.sh" ]; then
  echo "You must run the script in the lemp folder"
  exit 0
fi

HOST=$1

echo "Cleaning processed $HOST"
docker compose exec -T --user www-data php82-fpm /bin/bash -c "cd /var/www/$HOST && rm -rf var/view_preprocessed/ pub/static/* && bin/magento c:c && bin/magento c:f"

echo "$HOST - processed cleared"
