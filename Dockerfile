# image: sandinh/php-lamtuthien

FROM alpine:3.6

RUN apk add --no-cache php7-fpm php7-gd php7-imagick

EXPOSE 9000
CMD ["php-fpm7"]
