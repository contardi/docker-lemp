#!/bin/bash

CURRENTDIR=$(dirname "$0")
source $CURRENTDIR/.env

HOST=$1
BASEDIR=$(echo ${PWD} | sed -e "s/shell//g")
DIR="${BASEDIR}/var/www/$HOST"

COMPOSER_HOME=/var/www/.composer
DATABASE=$(echo ${HOST} | sed -e "s/\./_/g")

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

OPENSEARCH_HOSTNAME='opensearch'
OPENSEARCH_PREFIX=$(echo $HOST | sed -e "s/\.//g")

createDir() {
  echo "Verifying ${DIR}..."
  if [ ! -d "${DIR}" ]; then
    echo "Creating ${DIR}..."
    mkdir ${DIR}
  fi
}

addHost() {
  if [ -z "$(cat /etc/hosts | grep ${HOST})" ]
  then
      echo "Creating register in /etc/hosts, it'll need sudo permissions to write in /etc/hosts"
      sudo -s << EOF
      echo "127.0.0.1 ${HOST}" >> /etc/hosts
EOF

  fi
}

installMkCert() {
  echo "Installing mkcert"
  sudo apt install libnss3-tools -y
  wget https://github.com/FiloSottile/mkcert/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-linux-amd64
  sudo mv mkcert-${MKCERT_VERSION}-linux-amd64 /usr/local/bin/mkcert
  sudo chmod +x /usr/local/bin/mkcert

  mkcert -install
  mkcert -CAROOT
}

generateSignedCertificate() {
  echo "Generating Signed Certificates"
  mkcert -cert-file ${BASEDIR}/nginx/certificates/${HOST}.crt -key-file ${BASEDIR}/nginx/certificates/${HOST}.key ${HOST}

  echo "Update certificates"
  sudo update-ca-certificates
}

generateCertificate() {
  # create the certificate request
  echo "Verifying certificate"

  if [ ! $(command -v mkcert) >/dev/null  ]; then
    if [  -n "$(uname -a | grep Ubuntu)" ]; then
      installMkCert
    fi

    generateSignedCertificate
  fi

  generateUnsignedCertificate

}

generateUnsignedCertificate() {
  if [ ! -f ${BASEDIR}/nginx/certificates/${HOST}.crt ]; then
      echo "Generating unsigned certificate"
      COUNTRY=BR
      STATE=SP
      LOCALITY=SP
      SECTION=Ecommerce
      openssl req -newkey rsa:2048 -nodes \
          -keyout ${BASEDIR}/nginx/certificates/${HOST}.key -x509 -days 3650 -out ${BASEDIR}/nginx/certificates/${HOST}.crt \
          -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=${HOST}/OU=$SECTION/CN=${HOST}/emailAddress=admin@${HOST}"
    fi
}

verifySshKeys() {
  echo "Verifying SSH Keys"
  if [ ! -f ${BASEDIR}/ssh-keys/id_rsa ]; then
    echo "Copying SSH Keys"
    cp ~/.ssh/id_* ${BASEDIR}/ssh-keys/
    sudo chown www-data: ${BASEDIR}/ssh-keys/id_*
    sudo chmod 600 ${BASEDIR}/ssh-keys/id_*
  fi
}

copyMagento2Vhost() {
  if [ ! -f ${BASEDIR}/nginx/conf.d/examples/magento2.conf.example ]; then
    echo "You must have a file ${BASEDIR}/nginx/conf.d/examples/magento2.conf.example to be used as example to magento 2 vhost"
    exit 0
  fi

  echo "Generating vhost file"
  cp ${BASEDIR}/nginx/conf.d/examples/magento2.conf.example ${BASEDIR}/nginx/conf.d/${HOST}.conf
  sed -i "s/magento2.local/${HOST}/gi" ${BASEDIR}/nginx/conf.d/${HOST}.conf
}

copyDefaultSiteVhost() {
  if [ ! -f ${BASEDIR}/nginx/conf.d/examples/default.conf.example ]; then
    echo "You must have a file ${BASEDIR}/nginx/conf.d/examples/default.conf.example to be used as example to default vhost"
    exit 0
  fi

  echo "Generating vhost file"
  cp ${BASEDIR}/nginx/conf.d/examples/default.conf.example ${BASEDIR}/nginx/conf.d/${HOST}.conf
  sed -i "s/default.local/${HOST}/gi" ${BASEDIR}/nginx/conf.d/${HOST}.conf
}

setFilePermissions() {
  echo "Setting up file permissions"

  echo "Setting up www-data ownership"
  sudo chown -R www-data: ${DIR}/

  sudo chmod g+w ${DIR}/
  sudo chmod -R g+w ${DIR}/

}

createDatabase() {
  echo "Creating database"
  docker compose exec mysql mysql -h 127.0.0.1 -u root -proot -e "DROP DATABASE IF EXISTS $DATABASE;"
  docker compose exec mysql mysql -h 127.0.0.1 -u root -proot -e "CREATE DATABASE IF NOT EXISTS $DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
}

updateStore() {
  echo "Update store"
  docker compose exec -T --user www-data php81-fpm /bin/bash -c "
  cd /var/www/${HOST}/
  composer update && \
  bin/magento maintenance:enable && \
  bin/magento setup:upgrade && \
  bin/magento setup:di:compile && \
  rm -rf var/view_preprocessed/ pub/static/* && \
  bin/magento maintenance:disable && \
  bin/magento indexer:reindex && \
  bin/magento cache:enable && \
  bin/magento cache:clean && \
  bin/magento cache:flush
  "
}

updateGit() {
  echo "Update store"
  docker compose exec -T --user www-data php81-fpm /bin/bash -c "
  cd /var/www/${HOST}/

counter=0;

echo \"Updatings modules\";
# shellcheck disable=SC2045
for vendor in \$(ls \"/var/www/${HOST}/app/code\"); do
    for f in \$(ls \"/var/www/${HOST}/app/code/\${vendor}\"); do
        echo \"\${counter} - \${f}\";
        if [ -d \"/var/www/${HOST}/app/code/\${vendor}/\${f}/.git\" ]; then
            cd \"/var/www/${HOST}/app/code/\${vendor}/\${f}\";
            git config --global core.fileMode false;
            git config core.fileMode false;
            git pull;
            git status;
        fi
        counter=\$((counter+1));
    done
done

# shellcheck disable=SC2045
echo \"Updating Themes\";
for area in \$(ls \"/var/www/${HOST}/app/design\"); do
    for vendor in \$(ls \"/var/www/${HOST}/app/design/\${area}/\"); do
      for f in \$(ls \"/var/www/${HOST}/app/design/\${area}/\${vendor}/\"); do
          echo \"\$counter - \${f}\";
          if [ -d \"/var/www/${HOST}/app/design/\${area}/\${vendor}/\${f}/.git\" ]; then
              cd \"/var/www/${HOST}/app/design/\${area}/\${vendor}/\${f}\";
              git config core.fileMode false
              git config --global core.fileMode false
              git pull
	            git status
          fi
          counter=\$((counter+1));
      done
    done
done
  "
}

installM2() {
  if [ ! -f ${DIR}/app/etc/env.php ]; then
    echo "Installing a new version of Magento 2"

    sudo chown -R www-data: ${DIR}/

    docker compose exec -T php81-fpm /bin/bash -c "chown -R www-data: /var/www/"
    docker compose exec -T --user www-data php81-fpm /bin/bash -c "
    cd /var/www/${HOST}/

    composer clearcache
    ${PRE_INSTALL}
    composer config -g -a http-basic.repo.magento.com ${MAGENTO_AUTH_USER} ${MAGENTO_AUTH_PASS}
    composer create-project --repository=https://repo.magento.com/ magento/project-community-edition .

    bin/magento setup:install --base-url=${MAGENTO_URL} \
     --backend-frontname=${MAGENTO_BACKEND_FRONTNAME} \
     --language=${MAGENTO_LANGUAGE} \
     --timezone=${MAGENTO_TIMEZONE} \
     --currency=${MAGENTO_DEFAULT_CURRENCY} \
     --db-host=${MYSQL_HOST} \
     --db-name=${DATABASE} \
     --db-user=${MYSQL_USER} \
     --db-password=${MYSQL_PASSWORD} \
     --use-secure=${MAGENTO_USE_SECURE} \
     --base-url-secure=${MAGENTO_BASE_URL_SECURE}  \
     --use-secure-admin=${MAGENTO_USE_SECURE_ADMIN} \
     --use-rewrites=1 \
     --opensearch-host=${OPENSEARCH_HOSTNAME} \
     --opensearch-index-prefix=${OPENSEARCH_PREFIX} \
     --admin-firstname=${MAGENTO_ADMIN_FIRSTNAME} \
     --admin-lastname=${MAGENTO_ADMIN_LASTNAME} \
     --admin-email=${MAGENTO_ADMIN_EMAIL} \
     --admin-user=${MAGENTO_ADMIN_USERNAME} \
     --admin-password=\"${MAGENTO_ADMIN_PASSWORD}\"

    bin/magento maintenance:enable

    yes | bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis --cache-backend-redis-db=1
    yes | bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=2
    yes | bin/magento setup:config:set --session-save=redis --session-save-redis-host=redis --session-save-redis-log-level=4 --session-save-redis-db=3

    yes | bin/magento setup:config:set --lock-provider=file --lock-file-path=/var/www/${HOST}/var/lock/

    #Disable unused modules
    bin/magento module:disable Magento_Marketplace
    bin/magento module:disable Magento_Ups
    bin/magento module:disable Magento_Usps
    bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth Magento_TwoFactorAuth

    bin/magento deploy:mode:set developer

    bin/magento config:set web/cookie/cookie_lifetime 2592000
    bin/magento config:set web/seo/use_rewrites 1

    bin/magento config:set catalog/frontend/flat_catalog_category 1
    bin/magento config:set catalog/frontend/flat_catalog_product 1
    bin/magento config:set catalog/seo/product_url_suffix /
    bin/magento config:set catalog/seo/category_url_suffix /
    bin/magento config:set catalog/custom_options/time_format 24h
    bin/magento config:set catalog/custom_options/date_fields_order d,m,y

    bin/magento config:set customer/address/street_lines 4
    bin/magento config:set customer/address/company_show 0

    bin/magento config:set persistent/options/enabled 1

    bin/magento config:set admin/usage/enabled 0

    bin/magento config:set system/adobe_stock_integration/enabled 0

    bin/magento config:set dev/js/merge_files 0
    bin/magento config:set dev/js/enable_js_bundling 0
    bin/magento config:set dev/js/minify_files 0
    bin/magento config:set dev/css/merge_css_files 0
    bin/magento config:set dev/css/minify_files 0
    bin/magento config:set dev/static/sign 0

    bin/magento config:set admin/security/session_lifetime 31536000
    bin/magento config:set admin/security/password_lifetime ''
    bin/magento config:set admin/security/password_is_forced 0

    bin/magento setup:upgrade
    bin/magento setup:di:compile
    bin/magento maintenance:disable
    bin/magento indexer:reindex
    bin/magento cache:enable
    bin/magento cache:clean
    bin/magento cache:flush
    "
  else
    echo "${DIR} not empty, Magento 2 already installed"
  fi

}
