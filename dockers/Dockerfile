ARG IMAGE_NAME
ARG BASE_TAG

FROM ${IMAGE_NAME}:${BASE_TAG}

RUN apt-get update \
    && apt-get -y install nodejs

ARG PORT

ARG PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLiBgPMmIrkjc4D/It4oEHBxSiSw4yzrU6uxsxCWO5WqC/q2LiopMwpdO9Z2WxwNukLf2qUeofNoe2C+EuDNDqTvKF0e5SycBijtip4Ryz/MmX4BQofSlq1ikQbP7JYA31++lLNDha1bTgZW7DXcC+kiKkqF1jOCxh2dsU5xEs9zSV7xGQzy0J7vhUEZ/fgEPSIrqxiCfQlIZdrTzOhLfbjuIkzednCAsctgB95WPFcTWwEYO6geCe6+SN1pmBZzAvOKlE9S5TOIaCfVgGuEwvO+X+e/kxrCTg3/tmcG3krJ94apusMTsiRDB7Yts2tQQdz2Ux5tCP6hjEXwgUOed8TKdEVUo9madizeD1qjpwFOw8VmcdKxTyso3pXNlSZ9ZP77G44n2zBiV+urGEuSquVvlXVdmdUl2XMcHxsi6pH3SCQGOrg5s2PpHoOE9UO2X/YRsRv75jDYqzJWWH2QkHo/t+tWQCOKNEIsuzGODZ0jSQOase5RW4SQ77PrsTpfgFiAT3u/XqkqRldLBuNKK14y0Gnua3pFq/QeEWYl8QcyszSp+MPo+ytIEyx2+Gtm+luBe7Koik0fmNkS6n+YMo/nFd4RC5HOIS7HBpsgApA15YsqoE/rwjYLfTRgqZYCWh12lFLbkiVaQYTxB9AtogylVWuj8/4bF7sMn9qQG7mQ== boilerplate-dev-ssh"
RUN mkdir ~/.ssh
RUN echo $PUBLIC_KEY > ~/.ssh/authorized_keys
COPY dockers/sshd_config /etc/ssh/sshd_config

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