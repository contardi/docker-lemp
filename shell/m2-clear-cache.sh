#!/bin/bash

usage() {
  echo "Store importer M2 v 2.0
  Usage
  $ shell/m2-clear-cache.sh {destination}
   * destination: folder and host to be cleared, e.g. magento2.local
  "
}

if [ $# -eq 0 ]; then
  usage
  exit 0
fi

if [ ${0} != "shell/m2-clear-cache.sh" ]; then
  echo "You must run the script in the lemp folder"
  exit 0
fi

HOST=$1

echo "Cleaning $HOST"
docker compose exec -T --user www-data php81-fpm /bin/bash -c "cd /var/www/$HOST && bin/magento c:c && bin/magento c:f"

echo "$HOST - cache cleared"
