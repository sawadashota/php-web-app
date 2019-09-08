FROM php:7.3.9-buster

ENV APP_DIR /var/www/html
ENV HOME /home/app

# libzip version list
# https://libzip.org/download/
ENV LIBZIP_VERSION 1.5.2

WORKDIR $HOME

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libpq-dev \
        zlib1g-dev \
        imagemagick \
        libpng-dev \
        libgif-dev \
        libjpeg-dev \
        zip \
        unzip \
        git \
        ssh \
        cmake \
        apt-utils \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

WORKDIR /tmp/libzip
RUN curl -sSLO "https://libzip.org/download/libzip-${LIBZIP_VERSION}.tar.xz" \
    && tar Jxfv "libzip-${LIBZIP_VERSION}.tar.xz" \
    && rm -f "libzip-${LIBZIP_VERSION}.tar.xz"

WORKDIR /tmp/libzip/libzip-${LIBZIP_VERSION}/build
RUN cmake ../ \
    && make > /dev/null \
    && make install \
    && docker-php-ext-install zip pdo_mysql pdo_pgsql gd \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

WORKDIR $APP_DIR

RUN groupadd -r app && useradd -r -g app app \
    && chown -R app:app $APP_DIR \
    && chown -R app:app $HOME

USER app

