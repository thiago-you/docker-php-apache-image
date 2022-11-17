FROM php:7.4-fpm

LABEL Thiago You <thiago.youx@gmail.com>

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Set for all apt-get install, must be at the very beginning of the Dockerfile.
ENV DEBIAN_FRONTEND noninteractive

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install common and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    wget \
    apt-utils \
    curl \
    apt-transport-https \
    zip \
    unzip \
    supervisor \
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
    libpcre3-dev \
    # Install PHP source dependencies
    git \
    make \
    build-essential \
    autoconf \
    libtool \
    bison \
    re2c \
    pkg-config \
    openssl \
    sqlite3 \
    libsqlite3-dev \
    openssl \
    libssl-dev \
    libcurl4-openssl-dev \
    apache2-dev

# Download and build PHP lib from source
RUN git clone https://github.com/php/php-src.git --branch=PHP-7.4.33 --depth=1 && \ 
    mkdir /usr/local/php7.4 && \
    cd php-src && git status && \
    ./buildconf --force --build && \
    ./configure \
    --prefix=/usr/local/php \
    --sysconfdir=/etc/apache \
    --enable-so \
    --with-apxs2 \
    --libexecdir=/usr/local/php7.4/libexec \
    --enable-mbstring \
    --with-curl \
    --with-openssl \
    --with-xmlrpc \
    --enable-soap \
    --with-mysqli \
    --enable-embedded-mysqli \
    --with-freetype-dir \
    --enable-intl \
    --with-xsl \
    --with-zlib && \
    make -j4 && make install && \
    cd ../ && rm -rf php-src

# install external PHP modules before change init dir
RUN docker-php-ext-install intl && docker-php-ext-configure intl && \
    docker-php-ext-install mysqli && docker-php-ext-configure mysqli && \
    docker-php-ext-install zip && docker-php-ext-configure zip && \
    docker-php-ext-install xsl pdo_mysql bcmath calendar exif gd gettext mysqli pcntl shmop soap sockets sysvmsg sysvsem sysvshm xsl

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions psr
    
# Install memcached
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y libmemcached-dev \
    && MEMCACHED="`mktemp -d`" \
    && curl -skL https://github.com/php-memcached-dev/php-memcached/archive/master.tar.gz | tar zxf - --strip-components 1 -C $MEMCACHED \
    && docker-php-ext-configure $MEMCACHED \
    && docker-php-ext-install $MEMCACHED \
    && rm -rf $MEMCACHED

# PHP phalcon 4.1.0 env
ARG PSR_VERSION=1.2.0
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
        php7.4-gd \
        php7.4-intl \
        php7.4-mysql \
        php7.4-soap  \
        php7.4-psr \
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
RUN npm cache clean -f && npm install -g bower -g @angular/cli@12.2.10

# Installing packages
RUN apt-get update -y && \ 
    apt-get install -y --no-install-recommends xfonts-utils cabextract

# Install ttf-mscorefonts using DEB
RUN wget http://ftp.us.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb && \
    dpkg -i ttf-mscorefonts-installer_3.6_all.deb && \
    rm -f ttf-mscorefonts-installer_3.6_all.deb

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add apache2 config
RUN echo "AddType application/x-http-php  .php" >> /etc/apache2/apache2.conf && \
    echo "DirectoryIndex  index.php  index.html" >> /etc/apache2/apache2.conf && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Enable required apache mods.
RUN a2dismod mpm_worker mpm_event && \
    a2enmod rewrite headers proxy_http actions proxy_fcgi mpm_prefork

# Copy configs do image
COPY config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY supervisor /etc/supervisor

# start PHP FPM and APACHE2 services using supervisor
CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

# Print Node and PHP version
RUN node -v && \
    npm -v && \
    ng --version && \
    php -v && echo "\n"

# Expode HTTP and FCGI (FPM) port 
EXPOSE 80
EXPOSE 9000