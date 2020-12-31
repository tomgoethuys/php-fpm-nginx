FROM php:7.4-fpm-alpine

RUN apk add --no-cache nginx supervisor wget
RUN set -e; \
         apk add --no-cache \
                coreutils \
                freetype-dev \
                libjpeg-turbo-dev \
                libjpeg-turbo \
                libpng-dev \
                libzip-dev \
                jpeg-dev \
                icu-dev \
                zlib-dev \
                curl-dev \
                imap-dev \
                libxslt-dev libxml2-dev \
                libgcrypt-dev \
                oniguruma-dev \
                redis

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-configure intl
RUN docker-php-ext-configure imap

RUN set -e; docker-php-ext-install -j "$(nproc)" \
                gd soap imap bcmath mbstring iconv curl sockets \
                opcache \
                xsl \
                exif \
                mysqli pdo pdo_mysql \
                intl \
                zip

RUN mkdir -p /run/nginx

COPY docker/nginx/conf.d/app.conf /etc/nginx/nginx.conf

EXPOSE 8080
#CMD nginx && php-fpm
#ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
CMD sh /docker/startup-api.sh