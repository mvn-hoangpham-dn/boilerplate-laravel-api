#Image creation
#ARGS expected
#nginx:1.19.9
#php:8.0-fpm-buster

# Stage 1: Build PHP application
FROM php:8.0-fpm-buster AS app

WORKDIR /var/www/
# # Copy PHP application files to container
# COPY . /var/www/
# Install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils \
        curl \
        git \
        libgd-dev \
        libmcrypt-dev \
        libzip-dev \
        # php8.0-bcmath \
        # php8.0-gd \
        # php8.0-mysql \
        # php-pear \
        supervisor \
        unzip \
        vim \
        zip \
        libnginx-mod-http-headers-more-filter \
        # nginx-module-headers-more \
    # && pecl install mcrypt-1.0.1 \
    # && docker-php-ext-enable mcrypt \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-install gd zip \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Stage 2: Build Nginx server
FROM nginx:1.19.9 AS builder

# Copy PHP application files from previous stage
COPY --from=app ./ .

# Create user nginx
RUN addgroup --system nginx \
    && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false nginx

RUN sed -i \
    -e "s/user = www-data/user = nginx/g" \
    -e "s/group = www-data/group = nginx/g" \
    -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
    -e "s/;listen.owner = www-data/listen.owner = nginx/g" \
    -e "s/;listen.group = www-data/listen.group = nginx/g" \
    # -e "s/listen = \/run\/php\/php8.0-fpm.sock/listen = 127.0.0.1:9000/g" \
    -e "s/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/g" \
    -e "s/^;clear_env = no$/clear_env = no/" \
    /usr/local/etc/php-fpm.d/www.conf

# Config PHP.ini
COPY --from=app /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

RUN sed -i \
    # -e "s/;extension=pdo_mysql/extension=pdo_mysql/g" \
    -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" \
    -e "s/post_max_size = 8M/post_max_size = 28M/g" \
    -e "s/memory_limit = 128M/memory_limit = 512M/g" \
    /usr/local/etc/php/php.ini

# Copy Nginx configuration file to container
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d /etc/nginx/conf.d/

FROM builder

WORKDIR /var/www

COPY --chown=nginx:nginx . ./
ADD --chown=nginx:nginx ./dockers/start.sh /
ADD --chown=nginx:nginx ./nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
ADD --chown=nginx:nginx ./supervisor/conf.d/laravel-worker.conf /etc/supervisor/conf.d/laravel-worker.conf

RUN chown -R $USER:www-data storage bootstrap/cache
# RUN chmod -R 777 storage bootstrap/cache

RUN chmod +x /start.sh

RUN chown -R nginx:nginx /var/www/storage/
RUN composer self-update --2
RUN composer install --no-scripts

EXPOSE 80
# ENTRYPOINT [ "/start.sh" ]
CMD [ "/start.sh" ]
