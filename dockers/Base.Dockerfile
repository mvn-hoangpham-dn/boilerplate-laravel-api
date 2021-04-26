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

# Install header modules
FROM ${HTTPD_TAG} as builder

ENV MORE_HEADERS_VERSION=0.33
ENV MORE_HEADERS_GITREPO=openresty/headers-more-nginx-module

# Download sources
RUN wget "http://nginx.org/download/nginx-1.19.7.tar.gz" -O nginx.tar.gz && \
    wget "https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz" -O extra_module.tar.gz

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN  apk add --no-cache --virtual .build-deps \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    libxslt-dev \
    gd-dev \
    geoip-dev \
    perl-dev \
    libedit-dev \
    mercurial \
    bash \
    alpine-sdk \
    findutils

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

RUN rm -rf /usr/src/nginx /usr/src/extra_module && mkdir -p /usr/src/nginx /usr/src/extra_module && \
    tar -zxC /usr/src/nginx -f nginx.tar.gz && \
    tar -xzC /usr/src/extra_module -f extra_module.tar.gz

WORKDIR /usr/src/nginx/nginx-1.19.7

# Reuse same cli arguments as the nginx:alpine image used to build
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') && \
    sh -c "./configure --with-compat $CONFARGS --add-dynamic-module=/usr/src/extra_module/*" && make modules

# nginx:1.19.7-alpine
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

COPY --from=builder /usr/src/nginx/nginx-1.19.7/objs/*_module.so /etc/nginx/modules/
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d/
