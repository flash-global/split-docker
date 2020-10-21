FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update && \
    apt-get install -y --allow-unauthenticated \
    curl \
    ssh \
    php7.4 \
    php7.4-cli \
    php7.4-mysql \
    php7.4-xml \
    php7.4-soap \
    php7.4-json \
    php7.4-curl \
    php7.4-zip \
    php7.4-gd \
    php7.4-mbstring \
    php7.4-intl \
    php7.4-ldap \
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
COPY config/envvars /etc/apache2/envvars
COPY config/xdebug.ini /etc/php/7.4/mods-available/xdebug.ini

RUN a2enmod rewrite

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 0755 /start.sh
WORKDIR /var/www
CMD ["bash", "/start.sh"]
