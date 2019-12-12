FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update && \
    apt-get install -y --allow-unauthenticated \
    curl \
    ssh \
    php7.2 \
    php7.2-cli \
    php7.2-mysql \
    php7.2-xml \
    php7.2-soap \
    php7.2-json \
    php7.2-curl \
    php7.2-zip \
    php7.2-gd \
    php7.2-mbstring \
    php7.2-intl \
    php7.2-ldap \
    php-xdebug \
    php-common \
    php-memcached \
    composer \
    apache2 \
    libapache2-mod-php \
    mysql-client \
    && rm -rf /var/lib/apt/lists/*

COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY config/mime.conf /etc/apache2/mods-available/mime.conf
COPY config/xdebug.ini /etc/php/7.2/mods-available/xdebug.ini

RUN a2enmod rewrite

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 0755 /start.sh
WORKDIR /var/www
CMD ["bash", "/start.sh"]
