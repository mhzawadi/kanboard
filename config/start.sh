#!/bin/sh

cp /config/nginx_site.conf /etc/nginx/conf.d/default.conf
ln -s /dev/stdout /var/log/php7/error.log
ln -s /dev/stdout /var/log/nginx/access.log
ln -s /dev/stdout /var/log/nginx/error.log

cp /config/config.default.php /var/www/html/config.php;
chown nobody:nginx /var/www/html/config.php;

php-fpm7

exec "$@"
