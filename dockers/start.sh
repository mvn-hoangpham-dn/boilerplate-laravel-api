#!/bin/bash
composer self-update --2
composer install --no-interaction
composer dump-autoload --optimize
php artisan optimize:clear
php artisan migrate --force
service supervisor start
chmod -R 777 storage/
nginx
php-fpm
