#!/bin/bash
php artisan config:cache
composer self-update --2
composer install --no-interaction
composer dump-autoload --optimize
php artisan migrate --force
php artisan route:cache
service php7.3-fpm stop
service supervisor start
chmod -R 777 storage/
nginx
/usr/sbin/php-fpm7.3 -O
