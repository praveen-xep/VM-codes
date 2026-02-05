The best way to manage SSL certificates for NGINX in Docker is to use a **sidecar pattern**. This involves running a dedicated Certbot container alongside your NGINX container, sharing a volume for the certificates and the "webroot" challenge.

This approach is superior because it keeps your NGINX image "clean" (official image) and allows Certbot to handle renewals without stopping your web server.

### 1. The Strategy: Webroot Challenge

Instead of Certbot trying to "take over" port 80 (standalone mode), it will place a temporary challenge file in a shared folder. NGINX then serves that file to Let's Encrypt to prove you own the domain.

### 2. Implementation Guide

#### Step A: Prepare NGINX Configuration

You need a server block that redirects traffic to HTTPS but allows the Let's Encrypt challenge to pass through on port 80.

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    # Required for Certbot challenge
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

```

#### Step B: Docker Compose Setup

Create a `docker-compose.yml` that links the two services via shared volumes.

```yaml
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./certbot/conf:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    restart: always

  certbot:
    image: certbot/certbot
    volumes:
      - ./certbot/conf:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    # This command checks for renewal every 12 hours
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"

```

### 3. Initial Certificate Request

Since the renewal loop only works for *existing* certificates, you must run a one-time command to get your first cert:

```bash
docker compose run --rm certbot certonly --webroot --webroot-path=/var/www/certbot/ -d yourdomain.com

```

### 4. Automatic Reloading

Updating the certificate files on disk isn't enough; NGINX needs to reload them into memory. You can automate this by adding a deployment hook to the Certbot entrypoint or using a simple cron job on the host:

**Host Cron Job (Recommended):**

```bash
0 0 * * * docker exec nginx nginx -s reload

```

---

### Key Advantages

* **Zero Downtime:** NGINX never stops; it only reloads its configuration.
* **Security:** Certificates are stored in a persistent volume, so they survive container updates.
* **Separation of Concerns:** Your web server doesn't need to know how to talk to Let's Encrypt; it just serves files.

**Would you like me to help you draft the full SSL-enabled NGINX configuration (Port 443 block) now that you have the renewal strategy set up?**

```
net stop W3SVC
```