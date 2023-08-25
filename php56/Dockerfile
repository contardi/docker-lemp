FROM php:5.6-fpm

ARG USERGID
ARG USERUID
ARG USERNAME

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y imagemagick \
    vim \
    curl \
    libmcrypt-dev \
    autoconf \
    g++

RUN apt-get install -y \
    libtool \
    libpng-dev \
    openssl \
    libxml2-dev \
    libmemcached-dev

RUN apt-get install -y \
    musl \
    make \
    libpcre3 \
    iproute2 \
    libsodium-dev \
    libc-client-dev

RUN apt-get install -y \
    libpcre3-dev \
    libxslt1-dev \
    libmagickwand-dev \
    libmagickcore-dev

RUN apt-get install -y \
    golang-go \
    wget \
    git \
    rsync \
    software-properties-common \
    bash-completion \
    cron \
    gnupg \
    zip \
    python \
    apt-utils

RUN docker-php-ext-configure \
  	gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/;

RUN docker-php-ext-install bcmath \
    calendar \
    gd \
    intl \
    mcrypt \
    mysql \
    mysqli

RUN docker-php-ext-install opcache \
    pdo_mysql \
    simplexml \
    soap \
    sockets

RUN docker-php-ext-install tokenizer \
    xml \
    xmlrpc \
    xsl \
    zip

RUN cd /tmp && \
    git clone https://github.com/xdebug/xdebug.git && \
    cd xdebug && \
    git checkout xdebug_2_5 && \
    phpize && \
    ./configure --enable-xdebug && \
    make && \
    make install && \
    rm -rf /tmp/xdebug
RUN docker-php-ext-enable xdebug

RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host="`/sbin/ip route|awk '/default/ { print $3 }'` >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Code Sniffer
RUN composer global require "squizlabs/php_codesniffer=*"
RUN ln -s ~/.config/composer/vendor/bin/phpcs /usr/local/bin

# PHP MD
RUN composer global require "phpmd/phpmd=*"
RUN ln -s ~/.config/composer/vendor/bin/phpmd /usr/local/bin

# Mailhog to send email
ENV GOPATH=/opt/go
RUN mkdir /opt/go
RUN go get github.com/mailhog/mhsendmail \
    && echo "sendmail_path=\"/opt/go/bin/mhsendmail --smtp-addr='mailhog:1025'\"" > /usr/local/etc/php/conf.d/docker-php-ext-mailhog.ini

# For Magento Servers; Magerun Modman and Modgit
# Magerun
RUN wget https://files.magerun.net/n98-magerun-2.0.0.phar --no-check-certificate \
    && chmod +x ./n98-magerun-2.0.0.phar \
    && mv ./n98-magerun-2.0.0.phar /usr/local/bin/magerun

# Modman
RUN wget https://raw.githubusercontent.com/colinmollenhour/modman/master/modman -O /usr/local/bin/modman \
    && chmod +x /usr/local/bin/modman

# Modgit
RUN wget modgit https://raw.githubusercontent.com/jreinke/modgit/master/modgit -O \
    && chmod +x modgit \
    && mv modgit /usr/local/bin

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
