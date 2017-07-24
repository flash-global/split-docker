FROM ubuntu:16.04

MAINTAINER Jerome Schaeffer <jsc@opcoding.eu>

ENV DEBIAN_FRONTEND noninteractive
ENV APP_ENV dev

RUN apt-get -qq update && \
    apt-get install -y apache2 php7.0 libapache2-mod-php  \
    php7.0-cli php7.0-mysql php7.0-xml php7.0-soap \
    php7.0-mcrypt php7.0-json php7.0-curl php7.0-zip \
    pdftk a2ps htmldoc \
    php-xdebug ssh \
    && rm -rf /var/lib/apt/lists/*

COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY config/php.ini /etc/php/7.0/apache2/php.ini
COPY config/mime.conf /etc/apache2/mods-available/mime.conf
COPY config/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini

RUN a2enmod rewrite

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "start.sh"]