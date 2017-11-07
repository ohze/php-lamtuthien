# image: sandinh/php-lamtuthien

FROM php:7-fpm-alpine

RUN docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" pdo pdo_mysql && \
  rm -rf /var/cache/apk/*
