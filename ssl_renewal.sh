#!/bin/bash

# Renew SSL Certificate using Certbot and capture the output
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting SSL certificate renewal process..."

# Step 1: Stop NGINX container
echo "Stopping NGINX container..."
docker-compose stop nginx

