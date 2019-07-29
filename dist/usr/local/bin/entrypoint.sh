#!/bin/bash
set -eu

cd /var/www/html

if [ -f "cmsms-${CMSMS_VERSION}-install.php" ]
then
	echo "have the file ta"
else
	if [ "$(id -u)" = 0 ]; then
		rsync_options="--chown www-data:root"
	else
		rsync_options=""
	fi
	rsync $rsync_options /usr/src/cmsms-${CMSMS_VERSION}-install.php /var/www/html/
fi

if [ -f "cmsms-${CMSMS_VERSION}-install.php" ]
then
	echo 'got config'
else
	cp /config.template.php /var/www/html/config.php
	chown -R www-data:www-data /var/www/html/config.php
	if [ -n "${MYSQL_HOST+x}" ] && [ -n "${MYSQL_USER+x}" ] && [ -n "${MYSQL_PASSWORD+x}" ] && [ -n "${MYSQL_DATABASE+x}" ]; then
		sed -i -e "s/###MYSQL_HOST###/${MYSQL_HOST}/g" /var/www/html/config.php
		sed -i -e "s/###MYSQL_USER###/${MYSQL_USER}/g" /var/www/html/config.php
		sed -i -e "s/###MYSQL_PASSWORD###/${MYSQL_PASSWORD}/g" /var/www/html/config.php
		sed -i -e "s/###MYSQL_DATABASE###/${MYSQL_DATABASE}/g" /var/www/html/config.php
	fi
fi

if [[ -n "${REMOVE_INSTALL_FOLDER+x}" ]]
then
	echo "Removing install dir"
	rm -rfv cmsms-${CMSMS_VERSION}-install.php
	chown -R www-data:www-data /var/www/html/*
	chmod 0640 /var/www/html/config.php
else
	echo 'Making config.php writable'
	touch /var/www/html/config.php
	chown -R www-data:www-data /var/www/html/uploads
	chmod 0666 /var/www/html/config.php
fi

exec "$@"
