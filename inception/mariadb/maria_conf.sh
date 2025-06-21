#!/bin/bash
set -e

# Start MariaDB service
service mariadb start

sleep 5 # wait for mariadb to start

echo "MariaDB started. Initializing database..."

# until mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1;" &>/dev/null; do
#   echo "Waiting for MariaDB to be ready..."
#   sleep 2
# done

mariadb -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DB};"

# Create user if not exists
mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Grant privileges to user
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO '${MYSQL_USER}'@'%';"

# Flush privileges to apply changes
mariadb -e "FLUSH PRIVILEGES;"

# Shutdown mariadb to restart with new config
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# Restart mariadb with new config in the background to keep the container running
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'

