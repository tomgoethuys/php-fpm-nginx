FROM php:7.4-fpm-alpine

# Adding our services to the S6 expected location
COPY /docker/services.d /etc/services.d

# Adding the S6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

RUN apk add --no-cache nginx
RUN mkdir -p /run/nginx
EXPOSE 8080
COPY docker/nginx/conf.d/app.conf /etc/nginx/nginx.conf

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

# RUN set -e; docker-php-ext-install -j "$(nproc)" \
#                  #coreutils \
#                  gd soap bcmath mbstring iconv curl sockets \
#                  opcache \
#                  xsl \
#                  mysqli pdo pdo_mysql \
#                  zip \
#                  zlib-dev

ENTRYPOINT [ "/init" ]
# RUN set -e; \
#          apk add --no-cache \
#                 coreutils \
#                 freetype-dev \
#                 libjpeg-turbo-dev \
#                 libjpeg-turbo \
#                 libpng-dev \
#                 libzip-dev \
#                 jpeg-dev \
#                 icu-dev \
#                 zlib-dev \
#                 curl-dev \
#                 imap-dev \
#                 libxslt-dev libxml2-dev \
#                 libgcrypt-dev \
#                 oniguruma-dev \
#                 redis

# RUN docker-php-ext-configure gd --with-freetype --with-jpeg
# RUN docker-php-ext-configure intl
# RUN docker-php-ext-configure imap



# RUN mkdir -p /run/nginx

# COPY docker/ /docker/
# COPY docker/nginx/conf.d/app.conf /etc/nginx/nginx.conf
# COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#CMD nginx && php-fpm
#ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
# CMD sh /docker/startup-api.sh