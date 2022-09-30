FROM php:7.4-fpm

ARG USERGID
ARG USERUID
ARG USERNAME

RUN echo "deb https://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y imagemagick \
    vim \
    curl \
    libmcrypt-dev \
    autoconf \
    g++ \
    libtool \
    libpng-dev \
    libcurl4-openssl-dev \
    openssl \
    libxml2-dev \
    musl \
    make \
    libpcre3 \
    iproute2 \
    libc-client-dev \
    libpcre3-dev \
    libxslt1-dev \
    libmagickwand-dev \
    libmagickcore-dev \
    libmemcached-dev \
    libsodium-dev \
    libzip-dev \
    golang-go \
    git \
    rsync \
    software-properties-common \
    bash-completion \
    cron \
    gnupg \
    zip \
    wget \
    python \
    apt-utils

RUN docker-php-ext-configure \
  	gd --with-freetype --with-jpeg;

RUN docker-php-ext-install bcmath \
    calendar \
    curl \
    gd \
    intl \
    mysqli \
    opcache \
    pdo_mysql \
    simplexml \
    soap \
    sodium \
    sockets \
    tokenizer \
    xml \
    xmlrpc \
    xsl \
    zip

# PHP XDebug - 2.9.8 because of Magento
RUN pecl install xdebug-2.9.8 \
    && docker-php-ext-enable xdebug

RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host="`/sbin/ip route|awk '/default/ { print $3 }'` >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# PHP Imagick
RUN pecl install -f imagick \
    && docker-php-ext-enable imagick

# PHP MCrypt
RUN pecl install -f mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt

# PHP Memcache
RUN pecl install -f memcached \
    && docker-php-ext-enable memcached

# PHP MongoDB
RUN pecl install -f mongodb \
    && docker-php-ext-enable mongodb

# PHP OAuth
RUN pecl install -f oauth \
 	&& echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini

# PHP Redis
RUN pecl install -f redis \
	&& docker-php-ext-enable redis

# PDO PGSql
RUN apt-get install -y libpq-dev \
        && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
        && docker-php-ext-install pdo pdo_pgsql pgsql

# Node
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y build-essential nodejs

#Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

# Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Code Sniffer
RUN composer global require "squizlabs/php_codesniffer=*" \
    && composer global require magento-ecg/coding-standard
RUN ~/.config/composer/vendor/bin/phpcs --config-set installed_paths ~/.config/composer/vendor/magento-ecg/coding-standard
RUN ln -s ~/.config/composer/vendor/bin/phpcs /usr/local/bin

# PHP MD
RUN composer global require "phpmd/phpmd=*"
RUN ln -s ~/.config/composer/vendor/bin/phpmd /usr/local/bin

# Magerun for Magento users
RUN wget https://files.magerun.net/n98-magerun2.phar \
    && chmod +x ./n98-magerun2.phar \
    && mv ./n98-magerun2.phar /usr/local/bin/magerun2

# Mailhog to send email
ENV GOPATH=/opt/go
RUN mkdir /opt/go
RUN go get github.com/mailhog/mhsendmail \
    && echo "sendmail_path=\"/opt/go/bin/mhsendmail --smtp-addr='mailhog:1025'\"" > /usr/local/etc/php/conf.d/docker-php-ext-mailhog.ini

# 775 and 664 folder permissions
RUN echo "umask 0002" >> /etc/bash.bashrc
RUN echo "source /etc/profile.d/bash_completion.sh" >> /etc/bash.bashrc

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


