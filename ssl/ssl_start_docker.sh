#!/bin/bash

docker run -it --rm --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  -v "/certss:/var/www/certss" \
  certbot/certbot certonly --webroot \
  -w /var/www/certss \
  -d xeptest.duckdns.org \
  -d www.xeptest.duckdns.org

# 2. Tell the Nginx container to reload the new certificates
docker exec nginx nginx -s reload