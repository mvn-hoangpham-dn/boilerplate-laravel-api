#!/bin/bash
php artisan config:cache
composer self-update --2
composer install --no-interaction
npm install
composer dump-autoload --optimize
php artisan migrate
php artisan route:cache
service php7.3-fpm restart
service supervisor start
supervisorctl reread
supervisorctl update
# supervisorctl start laravel-worker:*
crond -l 2 -b
service ssh start
chmod -R 777 storage/
nginx -g 'daemon off;'
