FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

# Copy configuration file
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization script
COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# Create directory for the database
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Expose MariaDB port
EXPOSE 3306

# Run setup script as entrypoint
ENTRYPOINT ["setup.sh"]
CMD ["mysqld_safe"]
