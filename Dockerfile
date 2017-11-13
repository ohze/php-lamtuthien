# image: sandinh/php-lamtuthien

FROM alpine:3.6

# ensure www-data user exists
RUN set -x \
	&& addgroup -g 82 -S www-data \
	&& adduser -u 82 -D -S -G www-data www-data
# 82 is the standard uid/gid for "www-data" in Alpine
# http://git.alpinelinux.org/cgit/aports/tree/main/apache2/apache2.pre-install?h=v3.3.2
# http://git.alpinelinux.org/cgit/aports/tree/main/lighttpd/lighttpd.pre-install?h=v3.3.2
# http://git.alpinelinux.org/cgit/aports/tree/main/nginx-initscripts/nginx-initscripts.pre-install?h=v3.3.2

RUN apk add --no-cache \
        php7-fpm \
        php7-gd \
        php7-imagick \
        php7-mbstring \
        php7-pdo \
        php7-pdo_mysql \
        php7-json \
        php7-fileinfo \
        php7-session \
        php7-curl \
        php7-zlib \
        php7-zip \
        php7-iconv \
        php7-ctype \
        php7-tokenizer \
        php7-phar \
    && { \
        echo '[global]'; \
        echo 'error_log = /proc/self/fd/2'; \
        echo; \
        echo '[www]'; \
        echo '; if we send this to /proc/self/fd/1, it never appears'; \
        echo 'access.log = /proc/self/fd/2'; \
        echo; \
        echo 'clear_env = no'; \
        echo; \
        echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
        echo 'catch_workers_output = yes'; \
    } | tee /etc/php7/php-fpm.d/docker.conf \
    && { \
        echo '[global]'; \
        echo 'daemonize = no'; \
        echo; \
        echo '[www]'; \
        echo 'listen = [::]:9000'; \
    } | tee /etc/php7/php-fpm.d/zz-docker.conf

EXPOSE 9000
CMD ["php-fpm7"]
