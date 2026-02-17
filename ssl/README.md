# SSL Certificate Management
## Set up nginx
1) Update nginx docker compose file
```
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx_combine.conf:/etc/nginx/conf.d/default.conf
      - /var/www/letsencrypt:/var/www/letsencrypt
```
Note :- in addition to this there should be another volume attached to this container to get ssl certificate 
```
    volumes:
      - /etc/letsencrypt/live/xeptest.duckdns.org/fullchain.pem:/ssl_cert/fullchain.pem
      - /etc/letsencrypt/live/xeptest.duckdns.org/privkey.pem:/ssl_cert/privkey.pem
```
2) Update nginx config file to accept http requests from letsencrypt servers.
```cs
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    # Let's Encrypt Webroot Challenge Block
    location ^~ /.well-known/acme-challenge/ {
        allow all;
        root /var/www/letsencrypt;
        default_type "text/plain";
        try_files $uri =404;
    }

    # Redirect all other HTTP traffic to HTTPS
    location / {
        return 301 https://$host$request_uri;
    }
}
```
This setting will redirect all other traffics to https.

## Get Certificates first time.

Run this command to Get certificates first time.

```bash
docker run --rm --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  -v "/var/www/letsencrypt:/var/www/letsencrypt" \
  certbot/certbot certonly \
  --webroot \
  -w /var/www/letsencrypt \
  -d example.com -d www.example.com \
  --non-interactive \
  --agree-tos \
  --email me@example.com
```
Use ` --dry-run ` to test configarations

## Renew Certificates

To renew certificates use
```bash
docker run --rm --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  -v "/var/www/letsencrypt:/var/www/letsencrypt" \
  certbot/certbot renew \
  --webroot -w /var/www/letsencrypt\
  --non-interactive
```
# Automate renewal 

create a crone job to automate this.
create a file with the command.

```bash
# Runs at 3:00 AM and 3:00 PM every day
0 3 \* \* 2 /usr/local/bin/sslRenewal.sh >> /var/log/sslRenewal.log 2>\&1
```

