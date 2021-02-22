#Image creation
#ARGS expected
#phpdockerio/php73-fpm:latest
ARG PHP_TAG
ARG HTTPD_TAG

FROM ${PHP_TAG} as app

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

WORKDIR /var/www/

# Install selected extensions and other stuff
RUN apt-get update && apt-get install -y php7.3-pgsql php7.3-gd \
    && apt-get install -y php-pear \
    && apt-get install -y libmcrypt-dev \
    && apt-get install -y supervisor \
    && apt-get install -y openssh-server \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt \
    && apt-get install -y php-bcmath \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
    
# Install git
RUN apt-get update \
    && apt-get -y install zip \
    && apt-get -y install git \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN curl -sS https://getcomposer.org/installer | php \
    && php -r "readfile('https://getcomposer.org/installer');" | php

# nginx:1.17.4-alpine
FROM ${HTTPD_TAG}

ARG NGINX_FILE

COPY --from=app ./ .

RUN addgroup --system nginx \
    && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false nginx

RUN sed -i \
    -e "s/user = www-data/user = nginx/g" \
    -e "s/group = www-data/group = nginx/g" \
    -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
    -e "s/;listen.owner = www-data/listen.owner = nginx/g" \
    -e "s/;listen.group = www-data/listen.group = nginx/g" \
    -e "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 127.0.0.1:9000/g" \
    -e "s/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/g" \
    -e "s/^;clear_env = no$/clear_env = no/" \
    /etc/php/7.3/fpm/pool.d/www.conf

COPY nginx/conf.d /etc/nginx/conf.d/
