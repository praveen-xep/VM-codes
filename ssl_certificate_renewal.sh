#!/bin/bash

# Renew SSL Certificate using Certbot and capture the output
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting SSL certificate renewal process..."

# Step 1: Stop NGINX container and other containers
echo "Stopping NGINX container and other containers..."
# sudo docker-compose -f /home/ec2-user/carbon-sl/docker-compose-sl-image.yml down
sudo docker compose -f /home/ec2-user/carbon-sl/docker-compose-nginx.yml down

# Step 2: Start httpd server
echo "Starting httpd server ...."
sudo service httpd start

# Step 3: Renew SSL certificate
echo "Renewing ssl certificates ...."
sudo docker run --rm --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  -v "/var/www/html:/certss" \
  certbot/certbot renew --webroot -w /certss --noninteractive --agree-tos --register-unsafely-without-email
 
echo "Completed renewing certificates"

# Step 4: Stop http server after certificate renewal
echo "Stopping httpd server..."
sudo systemctl stop httpd

# Step 5: Restarting NGINX container and other containers
echo "Restarting NGINX container and other containers..."

bash "/home/ec2-user/carbon-sl/sl_backend_deploy.sh"
bash "/home/ec2-user/carbon-sl/sl_frontend_deploy.sh"
bash "/home/ec2-user/carbon-sl/nginx_deploy.sh"

# Success message after all deployment scripts have run
echo "$(date '+%Y-%m-%d %H:%M:%S') - All deployment scripts executed successfully."