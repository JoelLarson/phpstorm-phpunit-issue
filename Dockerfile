FROM php:7.4-cli

# Download script to install PHP extensions and dependencies
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

RUN DEBIAN_FRONTEND=noninteractive apt-get update -q \
    && apt-get install -qq -y \
        apt-utils \
        build-essential \
        gnupg \
        zip unzip libzip-dev \
    && pecl install xdebug \
    && docker-php-ext-install zip \
    && docker-php-ext-enable xdebug \
    && install-php-extensions \
        gd \
        intl \
        memcached \
        opcache

RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

#for medium sized image uploads w/o S3.
RUN echo "xdebug.mode=develop,coverage,debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=trigger" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.discover_client_host=false" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN chmod +x /usr/bin/composer

WORKDIR /var/www/html

COPY --chown=www-data:www-data source/ /var/www/html/

RUN mkdir -p /var/www/.composer && \
    chown www-data:www-data /var/www/.composer

USER www-data