#!/bin/bash
set -e

#------------------------------#
# WP-CLI installation
#------------------------------#

echo "Downloading WP-CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

echo "Making WP-CLI executable..."
chmod +x wp-cli.phar

echo "Moving WP-CLI to /usr/local/bin/wp..."
mv wp-cli.phar /usr/local/bin/wp

#------------------------------#
# WordPress directory permissions
#------------------------------#

echo "Setting permissions for /var/www/wordpress..."
chmod -R 755 /var/www/wordpress/

echo "Changing owner to www-data:www-data..."
chown -R www-data:www-data /var/www/wordpress

#------------------------------#
# WordPress installation with WP-CLI
#------------------------------#

cd /var/www/wordpress

echo "Downloading WordPress core..."
wp core download --allow-root

echo "Creating wp-config.php..."
wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root

echo "Installing WordPress..."
wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root

echo "Creating additional user..."
wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root

#------------------------------#
# PHP-FPM configuration
#------------------------------#

echo "Configuring PHP-FPM to listen on TCP port 9000..."
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

echo "Creating /run/php directory if it doesn't exist..."
mkdir -p /run/php

echo "Starting PHP-FPM in foreground..."
exec /usr/sbin/php-fpm7.4 -F
