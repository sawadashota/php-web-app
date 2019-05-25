FROM php:7.3.5

ENV APP_DIR /var/www/html
ENV HOME /home/app
ENV LIBZIP_VERSION 1.5.2

WORKDIR $HOME

RUN apt-get update \
    && apt-get install -y libpq-dev zlib1g-dev imagemagick libpng-dev libgif-dev libjpeg-dev zip unzip git ssh cmake apt-utils \
    && mkdir /tmp/libzip && cd /tmp/libzip && curl -sSLO https://libzip.org/download/libzip-${LIBZIP_VERSION}.tar.gz \
    && tar zxf libzip-${LIBZIP_VERSION}.tar.gz && cd libzip-${LIBZIP_VERSION}/ && mkdir build && cd build && cmake ../ \
    && make > /dev/null && make install \
    && docker-php-ext-install zip pdo_mysql pdo_pgsql gd \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

WORKDIR $APP_DIR

RUN groupadd -r app && useradd -r -g app app \
    && chown -R app:app $APP_DIR \
    && chown -R app:app $HOME

USER app
