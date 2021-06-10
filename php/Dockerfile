FROM php:7.4

LABEL Thiago You <thiago.youx@gmail.com>

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Set for all apt-get install, must be at the very beginning of the Dockerfile.
ENV DEBIAN_FRONTEND noninteractive

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install common and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
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

# PHP phalcon 4.1.0 env
ARG PSR_VERSION=1.0.1
ARG PHALCON_VERSION=4.1.0
ARG PHALCON_EXT_PATH=php7/64bits

# download and install PHP phalcon 4.1.0
RUN set -xe && \
    # Download PSR, see https://github.com/jbboehr/php-psr
    curl -LO https://github.com/jbboehr/php-psr/archive/v${PSR_VERSION}.tar.gz && \
    tar xzf ${PWD}/v${PSR_VERSION}.tar.gz && \
    # Download Phalcon
    curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
    tar xzf ${PWD}/v${PHALCON_VERSION}.tar.gz && \
    docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) \
        ${PWD}/php-psr-${PSR_VERSION} \
        ${PWD}/cphalcon-${PHALCON_VERSION}/build/${PHALCON_EXT_PATH} \
    && \
    # Remove all temp files
    rm -r \
        ${PWD}/v${PSR_VERSION}.tar.gz \
        ${PWD}/php-psr-${PSR_VERSION} \
        ${PWD}/v${PHALCON_VERSION}.tar.gz \
        ${PWD}/cphalcon-${PHALCON_VERSION} \
    && \
    php -m

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

# Installing packages
RUN apt-get install -y --no-install-recommends fontconfig xfonts-75dpi xfonts-utils cabextract

# Install ttf-mscorefonts using DEB
RUN wget http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb && \
    dpkg -i ttf-mscorefonts-installer_3.6_all.deb && \
    rm -f ttf-mscorefonts-installer_3.6_all.deb

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*