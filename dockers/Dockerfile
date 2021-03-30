ARG IMAGE_NAME
ARG BASE_TAG

FROM ${IMAGE_NAME}:${BASE_TAG}

RUN apt-get update \
    && apt-get -y install nodejs

ARG PORT

WORKDIR /var/www

COPY --chown=www-data:www-data . ./

ADD --chown=www-data:www-data ./dockers/start.sh /

ADD --chown=www-data:www-data ./nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
ADD --chown=www-data:www-data ./dockers/laravel-worker.conf /etc/supervisor/conf.d/laravel-worker.conf

RUN chmod +x /start.sh

RUN chmod -R 777 storage

RUN echo '* * * * *	php /var/www/artisan schedule:run >> /dev/null 2>&1' | cat - /etc/crontabs/root > temp && mv temp /etc/crontabs/root

EXPOSE ${PORT}

ENTRYPOINT [ "/start.sh" ]