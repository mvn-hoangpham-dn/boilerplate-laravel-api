#!/bin/bash
# php artisan config:cache
composer self-update --2
composer install --no-interaction
composer dump-autoload --optimize
php artisan migrate --force
php artisan route:cache
service supervisor start
service nginx start
chmod -R 777 storage/
php-fpm
