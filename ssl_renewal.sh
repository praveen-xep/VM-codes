#!/bin/bash

# Renew SSL Certificate using Certbot and capture the output
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting SSL certificate renewal process..."

echo "Stopping NGINX container..."
sudo docker stop nginx

echo "Starting SSL certificate renewal"
sudo certbot renew

echo "Starting nginx"
sudo docker start nginx





