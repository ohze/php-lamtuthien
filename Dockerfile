# image: sandinh/php-lamtuthien

FROM php:7-fpm-alpine

RUN docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" pdo pdo_mysql && \
  rm -rf /var/cache/apk/*

# install GD and mcrypt
RUN apk update && apk add \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# install Imagemagick & PHP Imagick ext
RUN apk update && apk add \
      libmagickwand-dev --no-install-recommends

RUN pecl install imagick && docker-php-ext-enable imagick
