# image: sandinh/php-lamtuthien

FROM php:7-fpm-alpine

RUN docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" pdo pdo_mysql && \
  rm -rf /var/cache/apk/*

# install GD and mcrypt
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
  docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} gd && \
  apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

# install Imagemagick & PHP Imagick ext
RUN apk add --no-cache imagemagick-dev \
        && pecl install imagick \
        && docker-php-ext-enable imagick \

# Clear
RUN apk del --no-cache autoconf g++ libtool make \
        && rm -rf /tmp/* /var/cache/apk/*
