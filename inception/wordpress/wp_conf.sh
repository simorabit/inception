#!/bin/bash
set -e


echo "🔧 Installing WP-CLI..."
curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

echo "📁 Preparing /var/www/wordpress directory..."
mkdir -p /var/www/wordpress
cd /var/www/wordpress
chown -R www-data:www-data .
chmod -R 755 .

#---------------------------------------------------#
# WordPress Installation
#---------------------------------------------------#
if [ ! -f wp-config.php ]; then
  echo "⬇️  Downloading WordPress core files..."
  wp core download --allow-root

  echo "⚙️  Creating wp-config.php..."
  wp core config \
    --dbhost=mariadb:3306 \
    --dbname="$MYSQL_DB" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --allow-root

  echo "🌐 Installing WordPress..."
  wp core install \
    --url="$DOMAIN_NAME" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN_N" \
    --admin_password="$WP_ADMIN_P" \
    --admin_email="$WP_ADMIN_E" \
    --allow-root

  echo "👤 Creating additional WordPress user..."
  wp user create "$WP_U_NAME" "$WP_U_EMAIL" \
    --user_pass="$WP_U_PASS" \
    --role="$WP_U_ROLE" \
    --allow-root
else
  echo "✅ WordPress already installed. Skipping download and install."
fi

#---------------------------------------------------#
# PHP-FPM Config
#---------------------------------------------------#

echo "🔧 Configuring PHP-FPM..."
sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf
# mkdir -p /run/php

echo "🚀 Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
