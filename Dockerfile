FROM php:7.3.0
MAINTAINER sawadashota <xiootas@gmail.com>

ENV APP_DIR /var/www/html
ENV HOME /home/app

WORKDIR $HOME

RUN apt-get update \
    && apt-get install -y libpq-dev zlib1g-dev imagemagick libpng-dev libgif-dev libjpeg-dev zip unzip \
    && docker-php-ext-install zip pdo_mysql pdo_pgsql gd \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

WORKDIR $APP_DIR

RUN groupadd -r app && useradd -r -g app app \
    && chown -R app:app $APP_DIR \
    && chown -R app:app $HOME

USER app
