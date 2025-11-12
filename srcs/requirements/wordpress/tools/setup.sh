#!/bin/bash
set -e

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
until mariadb -h mariadb -u"${MYSQL_USER}" -p"$(cat ${MYSQL_PASSWORD_FILE})" "${MYSQL_DATABASE}" &>/dev/null; do
    sleep 2
done
echo "MariaDB is up!"

# Move into WordPress directory
cd /var/www/html

# Configure WordPress if not already configured
if [ ! -f wp-config.php ]; then
    echo "Configuring WordPress..."
    cp wp-config-sample.php wp-config.php

    # Replace database settings
    sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
    sed -i "s/password_here/$(cat ${MYSQL_PASSWORD_FILE})/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
fi

# Install WP-CLI (command-line WordPress tool)
if ! command -v wp &>/dev/null; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Run WordPress installation if not already done
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="$(cat ${WP_ADMIN_PASSWORD_FILE})" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
fi

# Fix for PHP-FPM PID directory
mkdir -p /run/php
chown -R www-data:www-data /run/php

echo "WordPress setup complete!"
exec "$@"
