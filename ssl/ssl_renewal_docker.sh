docker run --rm --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  -v "/var/www/letsencrypt:/var/www/letsencrypt" \
  certbot/certbot renew \
  --webroot -w /var/www/letsencrypt\
  --non-interactive


## In your crontab -e
# 0 3 * * * docker run --rm --name certbot -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" -v "/var/www/letsencrypt:/var/www/letsencrypt" certbot/certbot renew --webroot -w /var/www/letsencrypt --non-interactive && docker exec nginx nginx -s reload
docker run --rm --name certbot -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" -v "/var/www/letsencrypt:/var/www/letsencrypt" certbot/certbot renew --webroot -w /var/www/letsencrypt --non-interactive && docker exec nginx nginx -s reload

docker run --rm --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  -v "/var/www/letsencrypt:/var/www/letsencrypt" \
  certbot/certbot certonly \
  --webroot \
  -w /var/www/letsencrypt \
  -d ohpc-test.xeptagon.com -d www.ohpc-test.xeptagon.com \
  --non-interactive \
  --agree-tos \
  --email praveenw@xeptagon.com \
  --dry-run