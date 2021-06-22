FROM php:7.4-apache

LABEL Thiago You <thiago.youx@gmail.com>

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Set for all apt-get install, must be at the very beginning of the Dockerfile.
ENV DEBIAN_FRONTEND noninteractive

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install common and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    apt-utils \
    curl \
    apt-transport-https \
    zip \
    unzip \
    g++ \
    zlib1g-dev \ 
    libicu-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libonig-dev \
    libmcrypt-dev \
    libzip-dev \
    libxslt1-dev \
    libpcre3-dev

# install external PHP modules before change init dir
RUN docker-php-ext-install intl && docker-php-ext-configure intl && \
    docker-php-ext-install mysqli && docker-php-ext-configure mysqli && \
    docker-php-ext-install zip && docker-php-ext-configure zip && \ 
    docker-php-ext-install xsl pdo_mysql bcmath calendar exif gd gettext mysqli pcntl shmop soap sockets sysvmsg sysvsem sysvshm xsl

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Persistent runtime dependencies
ARG DEPS="\
        php7.4 \
        php7.4-phar \
        php7.4-bcmath \
        php7.4-calendar \
        php7.4-mbstring \
        php7.4-exif \
        php7.4-ftp \
        php7.4-openssl \
        php7.4-zip \
        php7.4-sysvsem \
        php7.4-sysvshm \
        php7.4-sysvmsg \
        php7.4-shmop \
        php7.4-sockets \
        php7.4-zlib \
        php7.4-bz2 \
        php7.4-curl \
        php7.4-simplexml \
        php7.4-xml \
        php7.4-opcache \
        php7.4-dom \
        php7.4-xmlreader \
        php7.4-xmlwriter \
        php7.4-tokenizer \
        php7.4-ctype \
        php7.4-session \
        php7.4-fileinfo \
        php7.4-iconv \
        php7.4-json \
        php7.4-posix \
        php7.4-apache2 \
        php7.4-cli  \
        php7.4-dev \
        php7.4-common \
        php7.4-fpm \
        php7.4-gd \
        php7.4-intl \
        php7.4-mysql \
        php7.4-soap  \
        php7.4-pdo_mysql \
        php7.4-gettext \
        php7.4-mysqli \
        php7.4-pcntl \
        php7.4-xsl \
        curl \
        ca-certificates \
        runit \
        apache2 \
"

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.14.0

# Install nvm with  node and npm
RUN mkdir -p $NVM_DIR && curl https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install angular
RUN npm cache clean -f && npm install -g bower -g @angular/cli

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable apache mods.
RUN a2enmod rewrite

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND

RUN node -v
RUN npm -v
RUN ng --version