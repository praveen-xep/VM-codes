#!/bin/bash
docker exec nginx certbot renew --quiet && docker exec nginx nginx -s reload