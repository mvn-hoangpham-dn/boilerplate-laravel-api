ARG IMAGE_NAME
ARG BASE_TAG

FROM ${IMAGE_NAME}:${BASE_TAG}

ARG PORT

WORKDIR /var/www

COPY . ./

ADD ./dockers/start.sh /

RUN rm -f /etc/nginx/sites-enabled/default

ADD ./nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Config PHP.ini
COPY ./php/php.ini /usr/local/etc/php/php.ini

ADD ./supervisor/conf.d/laravel-worker.conf /etc/supervisor/conf.d/laravel-worker.conf

COPY package* ./

RUN chmod +x /start.sh

RUN chmod -R 777 storage

EXPOSE ${PORT}

ENTRYPOINT [ "/start.sh" ]
