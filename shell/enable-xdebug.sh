#!/bin/bash

usage() {
  echo "Enable XDebug
  Usage
  $ shell/disable-xdebug.sh {version}
   * version: PHP Version, e.g. php81
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

VERSION="php74"

if [ $# -eq 1 ]; then
  VERSION=$1
fi

docker-compose exec ${VERSION}-fpm mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.old /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
docker-compose restart ${VERSION}-fpm
