FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:ondrej/php
RUN apt-get -qq update && \
    apt-get install -y --allow-unauthenticated \
    curl \
    ssh \
    php8.0 \
    php8.0-cli \
    php8.0-mysql \
    php8.0-xml \
    php8.0-soap \
    php8.0-curl \
    php8.0-zip \
    php8.0-gd \
    php8.0-mbstring \
    php8.0-intl \
    php8.0-ldap \
    php-xdebug \
    php-common \
    php-memcached \
    apache2 \
    libapache2-mod-php \
    mysql-client \
    && rm -rf /var/lib/apt/lists/* \

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY config/php.ini /etc/php/8.0/apache2/php.ini
COPY config/mime.conf /etc/apache2/mods-available/mime.conf
COPY config/envvars /etc/apache2/envvars
COPY config/xdebug.ini /etc/php/8.0/mods-available/xdebug.ini

RUN a2enmod rewrite

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 0755 /start.sh
WORKDIR /var/www
CMD ["bash", "/start.sh"]
