FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    php7.4-fpm php7.4-mysql wget curl tar \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create WordPress directory
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Download and extract WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

# Copy setup script
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Copy PHP-FPM config if you want custom settings
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Expose PHP-FPM port
EXPOSE 9000

# Run setup script as entrypoint
ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["php-fpm7.4", "-F"]
