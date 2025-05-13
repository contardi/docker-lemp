#!/bin/bash

usage() {
  echo "Disable XDebug
  Usage
  $ bin/disable-xdebug.sh {version}
   * version: PHP Version, e.g. php82
  "
}
if [ "$1" == "-h" ] ; then
  usage;
  exit 0;
fi

if [ "$1" == "help" ] ; then
  usage;
  exit 0;
fi

VERSION="php82"

if [ $# -eq 1 ]; then
  VERSION=$1
fi

docker compose exec ${VERSION}-fpm mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.old
docker compose restart ${VERSION}-fpm
