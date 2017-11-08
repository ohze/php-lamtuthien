# image: sandinh/php-lamtuthien

FROM php:7-fpm-alpine

RUN docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" pdo pdo_mysql && \
  rm -rf /var/cache/apk/*

# install GD and mcrypt
RUN set -xe \
    # Update repository
    && apk update \
    && apk upgrade \

    # Add packages to compile the libraries
    && apk add --no-cache autoconf g++ libtool make \

    # GD
    && apk add --no-cache freetype-dev libjpeg-turbo-dev libxml2-dev libpng-dev \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \

    # Clear after install GD
    && apk del --no-cache freetype-dev libjpeg-turbo-dev libxml2-dev \

    # Clear
    && apk del --no-cache autoconf g++ libtool make \
    && rm -rf /tmp/* /var/cache/apk/*


# install imagick
RUN set -xe \
    # Update repository
    && apk update \
    && apk upgrade \

    # Add packages to compile the libraries
    && apk add --no-cache autoconf g++ libtool make \

    # ImageMagic
    && apk add --no-cache imagemagick-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \

    # Clear
    && apk del --no-cache autoconf g++ libtool make \
    && rm -rf /tmp/* /var/cache/apk/*