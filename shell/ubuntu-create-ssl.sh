#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Create Mkcert Script
Usage
$ shell/ubuntu-create-ssl.sh {hostname}

e.g. shell/ubuntu-create-ssl.sh magento2.local"
    exit 0
fi

VESRION="v1.4.3"
HOSTNAME=$1

if [ ! $(command -v mkcert) >/dev/null ]; then

  echo "Installing mkcert"
  sudo apt install libnss3-tools -y
  wget https://github.com/FiloSottile/mkcert/releases/download/${VESRION}/mkcert-${VESRION}-linux-amd64
  sudo mv mkcert-${VESRION}-linux-amd64 /usr/local/bin/mkcert
  sudo chmod +x /usr/local/bin/mkcert

  mkcert -install
  mkcert -CAROOT

fi

echo "Generating Certificates"
mkcert -cert-file nginx/certificates/${HOSTNAME}.crt -key-file nginx/certificates/${HOSTNAME}.key ${HOSTNAME} localhost 127.0.0.1 ::1

echo "Update certificates"
sudo update-ca-certificates

echo "Restarting nginx"
docker-compose restart webserver

echo "Veryfing nginx"
docker-compose ps webserver

echo "DONE, maybe it'll be necessary restart your browser"