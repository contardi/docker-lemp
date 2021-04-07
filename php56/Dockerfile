FROM php:5.6-fpm

ARG USERGID
ARG USERUID
ARG USERNAME

RUN apt-get update \ 
    && apt-get install -y imagemagick \ 
    vim \ 
    curl \
    libmcrypt-dev \ 
    autoconf \
    g++ \
    libtool \
    libpng-dev \
    openssl \
    libxml2-dev \
    libmemcached-dev \
    musl \
    make \
    libpcre3 \
    iproute2 \
    libsodium-dev \
    libc-client-dev \
    libcurl4-openssl-dev \
    libpcre3-dev \
    libxslt1-dev \
    libmagickwand-dev \
    libmagickcore-dev \
    golang-go \
    wget \
    git \
    software-properties-common \
    bash-completion \
    cron \
    gnupg \
    zip \
    apt-utils

RUN docker-php-ext-configure \
  	gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/;

RUN docker-php-ext-install bcmath \
    calendar \
    curl \
    gd \
    intl \
    mcrypt \
    mysql \
    mysqli \
    opcache \
    pdo_mysql \
    simplexml \
    soap \
    sockets \
    tokenizer \
    xml \
    xmlrpc \
    xsl \
    zip

# PHP XDebug
RUN pecl install xdebug-2.5.5 \
    && pecl channel-update pecl.php.net \
    && docker-php-ext-enable xdebug

RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host="`/sbin/ip route|awk '/default/ { print $3 }'` >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# PHP Imagick
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# PHP Memcache
RUN pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

# PHP OAuth
RUN pecl install oauth-1.2.3 \
 	&& echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini

# PHP Redis
RUN pecl install --force redis-4.3.0 \
	&& docker-php-ext-enable redis

# PDO PGSql
RUN apt-get install -y libpq-dev \
        && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
        && docker-php-ext-install pdo pdo_pgsql pgsql

# Node and Yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y build-essential nodejs

# Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Code Sniffer
RUN composer global require "squizlabs/php_codesniffer=*"
RUN ln -s ~/.config/composer/vendor/bin/phpcs /usr/local/bin

# Mailhog to send email
ENV GOPATH=/opt/go
RUN mkdir /opt/go 
RUN go get github.com/mailhog/mhsendmail \
    && echo "sendmail_path=\"/opt/go/bin/mhsendmail --smtp-addr='mailhog:1025'\"" > /usr/local/etc/php/conf.d/docker-php-ext-mailhog.ini

# For Magento Servers; Magerun Modman and Modgit
# Magerun
RUN wget https://files.magerun.net/n98-magerun.phar --no-check-certificate \
    && chmod +x ./n98-magerun.phar \
    && mv ./n98-magerun.phar /usr/local/bin/magerun
# Modman
RUN wget https://raw.githubusercontent.com/colinmollenhour/modman/master/modman -O /usr/local/bin/modman \
    && chmod +x /usr/local/bin/modman
# Modgit
RUN wget modgit https://raw.githubusercontent.com/jreinke/modgit/master/modgit -O \
    && chmod +x modgit \
    && mv modgit /usr/local/bin

# 775 and 664 folder permissions
RUN echo "umask 0002" >> /etc/bash.bashrc

# Fix current user permissions
RUN chown -R www-data: /var/www \
    && chsh -s /bin/bash www-data

RUN groupadd --gid ${USERGID} ${USERNAME} \
    && useradd --uid ${USERUID} --gid ${USERNAME} --shell /bin/bash --create-home ${USERNAME} \
    && usermod -aG www-data ${USERNAME} \
    && usermod -aG ${USERNAME} www-data

RUN cd /var/www \
    && find . -type d -exec chmod 775 {} \; \
    && find . -type f -exec chmod 664 {} \;

# Cleaning
RUN rm -rf /tmp/*

EXPOSE 9000
CMD ["php-fpm"]
