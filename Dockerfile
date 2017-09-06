FROM ubuntu:16.04

MAINTAINER Jerome Schaeffer <jsc@opcoding.eu>

ENV DEBIAN_FRONTEND noninteractive
ENV APP_ENV dev

RUN apt-get -qq update && \
    apt-get install -y apache2 language-pack-en-base software-properties-common python-software-properties && \
    locale-gen en_US.UTF-8  && LC_ALL=en_US.UTF-8 \
    add-apt-repository ppa:ondrej/php && apt-get -qq update && \
    apt-get install -y \
    php7.1 \
    php7.1-cli php7.1-mysql php7.1-xml php7.1-soap \
    php7.1-mcrypt php7.1-json php7.1-curl php7.1-zip php7.1-gd \
    mysql-client \
    php7.1-mbstring   \
    php-xdebug php-common \
    libapache2-mod-php7.1 \
    && rm -rf /var/lib/apt/lists/*

COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY config/php.ini /etc/php/7.1/apache2/php.ini
COPY config/mime.conf /etc/apache2/mods-available/mime.conf
COPY config/xdebug.ini /etc/php/7.1/mods-available/xdebug.ini

RUN a2enmod rewrite

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "start.sh"]
