FROM alpine:3.9.4
MAINTAINER Matthew Horwood <matt@horwood.biz>

RUN apk update \
    &&  apk add nginx php7-fpm php7-curl php7-dom php7-xml php7-xmlwriter \
        php7-tokenizer php7-simplexml php7-gd php7-gmp php7-gettext php7-pcntl \
        php7-mysqli php7-sockets php7-ctype php7-pecl-mcrypt php7-xmlrpc \
        php7-session composer php7-pdo_sqlite php7-sqlite3 \
    && rm -f /var/cache/apk/* \
    && mkdir -p /var/www/html/ \
    && mkdir -p /run/nginx;

ENV KB_SOURCE="https://github.com/kanboard/kanboard/archive/" \
    KB_VERSION="v1.2.14" \
    DB_DRIVER="sqlite" \
    MYSQL_HOST="mysql" \
    MYSQL_USER="root" \
    MYSQL_PASSWORD="my-secret-pw" \
    MYSQL_DB="invoiceplane" \
    MYSQL_PORT="3306"

COPY config /config
WORKDIR /var/www/html
ADD ${KB_SOURCE}/${KB_VERSION}.zip /tmp/
RUN unzip /tmp/${KB_VERSION}.zip -d /var/www/ && \
    cp -R /var/www/kanboard-${KB_VERSION}/* /var/www/html/ && \
    chmod +x /config/start.sh; \
    cp /config/php.ini /etc/php7/php.ini && \
    cp /config/php_fpm_site.conf /etc/php7/php-fpm.d/www.conf; \
    chown nobody:nginx /var/www/html/* -R;

VOLUME /var/www/html/data /var/www/html/plugins
EXPOSE 80
ENTRYPOINT ["/config/start.sh"]
CMD ["nginx", "-g", "daemon off;"]
