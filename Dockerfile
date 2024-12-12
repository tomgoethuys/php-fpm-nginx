FROM --platform=linux/x86_64 php:8.2-apache
RUN apt-get update
RUN apt-get install -y libzip-dev zip git libpng-dev libwebp-dev libjpeg62-turbo-dev libfreetype6-dev libmagickwand-dev && docker-php-ext-install zip mysqli pdo pdo_mysql opcache
RUN pecl install imagick
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && docker-php-ext-install gd && docker-php-ext-enable imagick
RUN a2enmod rewrite
RUN mkdir ~/.ssh
RUN ssh-keyscan -t ecdsa github.com >> ~/.ssh/known_hosts 
RUN chown -R www-data:www-data /var/www
COPY docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY docker/php/settings.ini /usr/local/etc/php/conf.d/settings.ini
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf
RUN sed "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /usr/local/etc/php/php.ini-development
RUN sed "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /usr/local/etc/php/php.ini-production
RUN curl http://getcomposer.org/download/2.8.4/composer.phar --output composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer
#docker build -t smooty8.2 . --no-cache --platform linux/amd64
#docker tag 56eff6fb265b tgoethuys/php-fpm8.2-nginx:latest
#docker push tgoethuys/php-fpm8.2-nginx:latest

