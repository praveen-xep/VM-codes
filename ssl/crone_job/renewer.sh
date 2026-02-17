#!/bin/bash

# Get the full path to docker (standard on Amazon Linux)
DOCKER_BIN=$(which docker || echo "/usr/bin/docker")

echo "--------------------------------------------"
echo "Renewal attempt started at: $(date)"
echo "--------------------------------------------"

# Run Certbot container
# Added --quiet to keep logs clean unless there is an error
$DOCKER_BIN run --rm --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  -v "/var/www/letsencrypt:/var/www/letsencrypt" \
  certbot/certbot renew \
  --webroot -w /var/www/letsencrypt \
  --non-interactive \
  --post-hook "echo 'Certificates updated, reloading Nginx...'"

# Reload Nginx container
echo "Reloading Nginx configuration..."
$DOCKER_BIN exec nginx nginx -s reload

echo "Process complete."