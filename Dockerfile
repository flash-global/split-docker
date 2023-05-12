FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV APP_ENV dev

RUN apt-get -qq update && \
    apt-get install -y --allow-unauthenticated apache2 php7.0 libapache2-mod-php imagemagick curl\
    php7.0-cli php7.0-mysql php7.0-xml php7.0-soap \
    php7.0-mcrypt php7.0-json php7.0-curl php7.0-zip php7.0-gd \
    pdftk a2ps htmldoc mysql-client \
    php7.0-mbstring \
    php7.0-intl \
    php7.0-ldap \
    php-memcache \
    php-memcached \
    php-xdebug ssh php-common \
    && rm -rf /var/lib/apt/lists/*

# the last part is usefull if you decide to do some updates though you ain't supposed to do so

COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY config/php.ini /etc/php/7.0/apache2/php.ini
COPY config/mime.conf /etc/apache2/mods-available/mime.conf
COPY config/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini

#Symlinks for PDF executable
RUN ln -s /usr/bin/psjoin /usr/local/bin/psjoin \
    && ln -s /usr/bin/gs /usr/local/bin/gs

# For aws SDK signing usage
RUN curl -LJO https://rolesanywhere.amazonaws.com/releases/1.0.3/X86_64/Linux/aws_signing_helper && chmod +x ./aws_signing_helper && cp ./aws_signing_helper /bin/

RUN a2enmod rewrite

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 0755 /start.sh
WORKDIR /var/www
CMD ["bash", "/start.sh"]
