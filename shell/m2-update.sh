#!/bin/bash

CURRENTDIR=$(dirname "$0")
echo "importing $CURRENTDIR/functions.sh"
source $CURRENTDIR/functions.sh

usage() {
  echo "Store importer M2 v 2.0
  Usage
  $ shell/m2-update.sh {destination}
   * destination: folder and host to be created, e.g. magento2.local
  "
}

if [ $# -eq 0 ]; then
  usage
  exit 0
fi

if [ ${0} != "shell/m2-update.sh" ]; then
  echo "You must run the script in the lemp folder"
  exit 0
fi

HOST=$1
updateStore

echo "DONE"