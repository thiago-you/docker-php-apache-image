FROM thiagoyou/cpn-php:fpm

LABEL Thiago You <thiago.youx@gmail.com>

# Arguments defined in docker-compose.yml
ARG user
ARG uid

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
    wkhtmltopdf

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# copy PHP config
COPY ./config/php.ini /usr/local/etc/php/

# copy PHP Source Guardian extension
COPY ./config/extensions/ixed.7.4.lin /usr/local/lib/php/extensions/no-debug-non-zts-20190902

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

# Expose angular serve port
EXPOSE 4200

# Expose node server port
EXPOSE 3000

# Expose PHP-FPM port
EXPOSE 9000