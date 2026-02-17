#!/bin/bash

# Check if domain is provided
if [ -z "$1" ]; then
    echo "Usage: ./setup_ssl.sh yourdomain.duckdns.org"
    exit 1
fi

DOMAIN=$1
CONTAINER_NAME="nginx" # Change this if your container name is different

echo "--- 🛠️ Preparing $CONTAINER_NAME container ---"

# 1. Update and Install Certbot inside the container
docker exec -u 0 -it $CONTAINER_NAME apt update
docker exec -u 0 -it $CONTAINER_NAME apt install python3-certbot-nginx -y

echo "--- 🔐 Requesting Certificate for $DOMAIN ---"

# 2. Run Certbot
# --nginx: Automatically finds your server block and configures it
# --non-interactive: Doesn't wait for user prompts (requires email)
# --agree-tos: Accepts Let's Encrypt Terms of Service
docker exec -it $CONTAINER_NAME certbot --nginx \
    -d $DOMAIN \
    --non-interactive \
    --agree-tos \
    --register-unsafely-without-email

echo "--- 🔄 Reloading Nginx ---"

# 3. Reload Nginx to apply changes
docker exec -it $CONTAINER_NAME nginx -s reload

echo "--- ✅ Done! Try visiting https://$DOMAIN ---"