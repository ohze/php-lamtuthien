# image: sandinh/php-lamtuthien

FROM php:7-fpm-alpine

RUN apk add --update \
        freetype libpng libjpeg-turbo imagemagick \
    && apk add --virtual .build-dep \
        gcc make autoconf libc-dev freetype-dev libpng-dev libjpeg-turbo-dev pcre-dev imagemagick-dev \
    && pecl install imagick \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" gd pdo pdo_mysql \
    && docker-php-ext-enable imagick \
    && apk del .build-dep \
    && rm -rf /var/cache/apk/*
