crontab -e
0 3 * * * docker exec nginx certbot renew --quiet && docker exec nginx nginx -s reload