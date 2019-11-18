ARG MH_ARCH
ARG MH_TAG
FROM ${MH_ARCH}:${MH_TAG}
MAINTAINER Matthew Horwood <matt@horwood.biz>

ENV KANBOARD_VERSION 1.2.12
ENV KANBOARD_TARBALL https://github.com/kanboard/kanboard/archive/v${KANBOARD_VERSION}.tar.gz

VOLUME ["/var/www/html/kanboard", "/var/www/html/kanboard/data"]
WORKDIR /var/www/html

RUN apt-get update && \
    apt-get -y install wget curl zip libzip-dev libgd-dev rsync && \
    apt-get clean; \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
    docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install -j$(nproc) zip; \
    docker-php-ext-install -j$(nproc) \
          mysqli \
          gd \
          opcache; \
    a2enmod rewrite; \
    cd /usr/src && \
    wget ${KANBOARD_TARBALL} && \
    cd /var/www/html && \
    tar --strip 1 -xzf /usr/src/v${KANBOARD_VERSION}.tar.gz && \
    chown -R www-data:www-data /var/www/html/*

CMD ["apache2-foreground"]
