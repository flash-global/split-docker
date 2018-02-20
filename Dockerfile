FROM ubuntu:16.04

MAINTAINER Jerome Schaeffer <jsc@opcoding.eu>

ENV DEBIAN_FRONTEND noninteractive
ENV APP_ENV dev

RUN apt-get -qq update && \
    apt-get install -y --allow-unauthenticated apache2 php7.0 libapache2-mod-php imagemagick\
    php7.0-cli php7.0-mysql php7.0-xml php7.0-soap \
    php7.0-mcrypt php7.0-json php7.0-curl php7.0-zip php7.0-gd \
    pdftk a2ps htmldoc mysql-client \
    php7.0-mbstring \
    php-xdebug ssh php-common curl \
    && rm -rf /var/lib/apt/lists/*

# replace the php memcache with a fixed one
COPY php-memcache/php-memcache_3.0.9-20151130.fdbd46b-2.flash1_amd64.deb /home/php-memcache_3.0.9-20151130.fdbd46b-2.flash1_amd64.deb
RUN dpkg -i /home/php-memcache_3.0.9-20151130.fdbd46b-2.flash1_amd64.deb \
    && echo php-memcache hold | dpkg --set-selections \
    && rm /home/php-memcache_3.0.9-20151130.fdbd46b-2.flash1_amd64.deb

# install node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# the last part is usefull if you decide to do some updates though you ain't supposed to do so

COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY config/php.ini /etc/php/7.0/apache2/php.ini
COPY config/mime.conf /etc/apache2/mods-available/mime.conf
COPY config/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini

#Symlinks for PDF executable
RUN ln -s /usr/bin/psjoin /usr/local/bin/psjoin \
    && ln -s /usr/bin/gs /usr/local/bin/gs

RUN a2enmod rewrite

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "start.sh"]
