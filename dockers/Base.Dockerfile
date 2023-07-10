#Image creation
#ARGS expected
#php:7.3-fpm-buster
ARG PHP_TAG
ARG HTTPD_TAG

FROM ${PHP_TAG} as app

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

WORKDIR /var/www/

# Install extension
RUN apt-get update && apt-get install git libzip-dev libonig-dev libpq-dev zip npm -y \
    && docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-install zip \
    && apt-get install -y vim \
    && apt-get install -y awscli \
    && apt-get install -y cron \
    && apt-get install -y wget \
    && apt-get install -y curl \
    && apt-get install -y supervisor

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install header modules
FROM ${HTTPD_TAG} as builder

ENV MORE_HEADERS_VERSION=0.33
ENV MORE_HEADERS_GITREPO=openresty/headers-more-nginx-module

# Download sources
RUN wget "http://nginx.org/download/nginx-1.19.7.tar.gz" -O nginx.tar.gz && \
    wget "https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz" -O extra_module.tar.gz

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN apk add --no-cache --virtual .build-deps \
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

COPY --from=app ./ ./temp
RUN rm -rf ./temp/var/lib/buildkit/
RUN cp -r ./temp/* . || true && rm -rf ./temp

# Create nginx user/group first, to be consistent throughout Docker variants
RUN addgroup --system nginx \
    && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false nginx

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs && apt-get clean

COPY --from=builder /usr/src/nginx/nginx-1.19.7/objs/*_module.so /etc/nginx/modules/
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d/
