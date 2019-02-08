FROM php:7.2-fpm

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
    gd \
    intl \
    mbstring \
    mysqli \
    opcache \
    pdo_mysql \
    soap \
    sockets \
    xml \
    xmlrpc \
    xsl \
    zip

# PHP XDebug
RUN pecl install xdebug \
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

# PHP MCrypt
RUN pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt

# PHP Memcache
RUN pecl install memcached \
    && docker-php-ext-enable memcached

# PHP MongoDB
RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

# PHP OAuth
RUN pecl install oauth \
 	&& echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini

# PHP Redis
RUN pecl install --force redis \
	&& docker-php-ext-enable redis

# Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Code Sniffer
RUN composer global require "squizlabs/php_codesniffer=*" \
    && composer global require magento-ecg/coding-standard \
    && ~/.composer/vendor/bin/phpcs --config-set installed_paths ~/.composer/vendor/magento-ecg/coding-standard
RUN ln -s ~/.composer/vendor/bin/phpcs /usr/local/bin;
ENV PATH="/var/www/.composer/vendor/bin/:${PATH}"

# Node and Yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  	&& apt-get install -y build-essential nodejs \
    && apt -y install --no-install-recommends yarn

# Mailhog to send email
ENV GOPATH=/opt/go
RUN mkdir /opt/go 
RUN go get github.com/mailhog/mhsendmail \
    && echo "sendmail_path=\"/opt/go/bin/mhsendmail --smtp-addr='mailhog:1025'\"" > /usr/local/etc/php/conf.d/docker-php-ext-mailhog.ini

# 775 and 664 folder permissions
RUN echo "umask 0002" >> /etc/bash.bashrc

# Fix current user permissions
RUN chown -R www-data: /var/www \
    && chsh -s /bin/bash www-data

RUN groupadd --gid ${USERGID} ${USERNAME} \
    && useradd --uid ${USERUID} --gid ${USERNAME} --shell /bin/bash --create-home ${USERNAME} \
    && usermod -aG www-data ${USERNAME} \
    && usermod -aG ${USERNAME} www-data

# Cleaning
RUN rm -rf /tmp/*

EXPOSE 9000
CMD ["php-fpm"]

