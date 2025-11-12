FROM debian:bullseye

# Install nginx and openssl for HTTPS
RUN apt-get update && apt-get install -y nginx openssl && rm -rf /var/lib/apt/lists/*

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificates
RUN openssl req -x509 -nodes -days 365 \
    -subj "/C=MA/ST=Casa/L=Casa/O=42/OU=Inception/CN=amaaouni.42.fr" \
    -newkey rsa:2048 -keyout /etc/nginx/ssl/amaaouni.key \
    -out /etc/nginx/ssl/amaaouni.crt

# Copy nginx configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose HTTP and HTTPS ports
EXPOSE 443

# Launch nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
