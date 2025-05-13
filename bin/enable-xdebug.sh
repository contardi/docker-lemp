#!/bin/bash

usage() {
  echo "Enable XDebug
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

docker compose exec ${VERSION}-fpm mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.old /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
docker compose restart ${VERSION}-fpm


#zend_extension=xdebug
#xdebug.mode=debug,coverage
#xdebug.start_with_request=yes
#xdebug.log_level=0
#xdebug.client_port=9003
#xdebug.remote_handler=dbgp
#xdebug.discover_client_host=off
#xdebug.idekey=PHP
#xdebug.client_host=172.17.0.1

