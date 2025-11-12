#!/bin/bash
set -e

# Initialize database directory if empty
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

# Start MySQL server temporarily in the background
mysqld_safe --skip-networking &
MYSQL_PID=$!

# Wait until MariaDB is ready
echo "Waiting for MariaDB to start..."
until mysqladmin ping &>/dev/null; do
    sleep 1
done

# Read secrets
ROOT_PASS=$(cat ${MYSQL_ROOT_PASSWORD_FILE})
USER_PASS=$(cat ${MYSQL_PASSWORD_FILE})
ADMIN_PASS=$(cat ${MYSQL_ADMIN_PASS_FILE})

# Create database and users
mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${USER_PASS}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
CREATE USER IF NOT EXISTS '${MYSQL_ADMIN}'@'%' IDENTIFIED BY '${ADMIN_PASS}';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASS}';
FLUSH PRIVILEGES;
EOF

# Stop temporary server
mysqladmin -u root -p"${ROOT_PASS}" shutdown
wait $MYSQL_PID || true
fi
# Run the main server (PID 1)
exec mysqld_safe
