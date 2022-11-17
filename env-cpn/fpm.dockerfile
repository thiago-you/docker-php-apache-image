FROM thiagoyou/cpn-php:fpm

LABEL Thiago You <thiago.youx@gmail.com>

# Define user
ARG user=cpn
ARG uid=1000

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Set for all apt-get install, must be at the very beginning of the Dockerfile.
ENV DEBIAN_FRONTEND noninteractive

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user && \
    mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Install common and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    apt-utils \
    apt-transport-https \
    zip \
    unzip \
    vim \
    nano \
    tar

# add debian source to install PDF plugin
RUN echo "deb http://deb.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list.d/source.list && \
    echo "deb-src http://deb.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list.d/source.list

# Install common and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    fontconfig \
    xfonts-base \
    xfonts-75dpi \
    libxrender1 \
    libxext6 \
    libxcb1 \
    libx11-6 \
    multiarch-support

# copy PDF plugin and dependency installer .deb
COPY ./plugins/libjpeg-turbo8_1.5.2-0ubuntu5.18.04.6_amd64.deb /usr/local/lib/libjpeg-turbo8_1.5.2-0ubuntu5.18.04.6_amd64.deb
COPY ./plugins/wkhtmltox_0.12.5-1.bionic_amd64.deb /usr/local/lib/wkhtmltox_0.12.5-1.bionic_amd64.deb

# install PDF plugin and dependency
RUN cd /usr/local/lib/ && \
    dpkg -i libjpeg-turbo8_1.5.2-0ubuntu5.18.04.6_amd64.deb && \
    dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb && \
    apt-get install -y -f && \
    rm libjpeg-turbo8_1.5.2-0ubuntu5.18.04.6_amd64.deb && \
    rm wkhtmltox_0.12.5-1.bionic_amd64.deb

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# copy PHP config
COPY ./config/php.ini /usr/local/etc/php/

# copy PHP Source Guardian extension
COPY ./config/ixed.7.4.lin /usr/local/lib/php/extensions/no-debug-non-zts-20190902

# Set working directory
WORKDIR /var/www/html

# set php session permission, uncoment php extension from mime.types
# and enable apache2 SSL
RUN mkdir -p /var/lib/php/sessions && \
    chown -R www-data:www-data /var/lib/php/sessions && \
    sed -i '/x-httpd-php/s/^#//g' /etc/mime.types && \
    a2enmod ssl 

# add aliases into bash
RUN echo "# bash aliases" >> ~/.bashrc && \
    echo "alias ll='ls -alF'" >> ~/.bashrc && \
    echo "alias la='ls -A'" >> ~/.bashrc && \
    echo "alias l='ls -CF'" >> ~/.bashrc && \
    echo "alias lt='du -sh * | sort -h'" >> ~/.bashrc && \
    echo "alias size='du -sh'" >> ~/.bashrc && \
    echo "alias left='ls -t -1'" >> ~/.bashrc && \
    echo "alias count='find . -type f | wc -l'" >> ~/.bashrc && \
    echo "alias untar='tar -zxvf'" >> ~/.bashrc && \
    echo "alias wget='wget -c'" >> ~/.bashrc && \
    echo "alias .html='cd /var/www/html'" >> ~/.bashrc && \
    echo "alias .sites='cd /etc/apache2/sites-enabled'" >> ~/.bashrc && \
    echo "alias .php='cd /usr/local/etc/php/'" >> ~/.bashrc && \
    echo "alias ...='cd ../../../'" >> ~/.bashrc && \
    echo "alias ....='cd ../../../../'" >> ~/.bashrc && \
    echo "alias .3='cd ../../../'" >> ~/.bashrc && \
    echo "alias .4='cd ../../../../'" >> ~/.bashrc && \
    echo "alias .5='cd ../../../../../'" >> ~/.bashrc && \
    echo "alias rm='rm -I --preserve-root'" >> ~/.bashrc && \
    echo "alias sudo=''" >> ~/.bashrc

# Expose apache2 port
EXPOSE 80

# Expose apache2 SSL port
EXPOSE 443