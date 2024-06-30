#!/bin/sh

# Waits for proxy to be available, then gets the certificate for each allowed host.
set -e

# Use netcat (nc) to check port 80, and keep checking every 5 seconds
# until it is available. This is so nginx has time to start before
# certbot runs.
until nc -z proxy 80; do
  echo "Waiting for proxy..."
  sleep 5s
done


#ALLOWED_HOSTS=$(grep -o 'ALLOWED_HOSTS=[^[:space:]]*' .env | cut -d'=' -f2)

CERTBOT_DOMAINS=$(python -c "import re; s = '$ALLOWED_HOSTS'.split(','); s = [host for host in s if not re.match('^localhost$|^(\d{1,3}\.){3}\d{1,3}$', host)]; print(' '.join(' '.join(['-d', host]) for host in s))")

## Remove leading whitespace
CERTBOT_DOMAINS=${CERTBOT_DOMAINS# }

if [ -n "$CERTBOT_DOMAINS" ]; then
    echo "Getting certificates for domains: $CERTBOT_DOMAINS..."

    sh -c "certbot certonly \
        --webroot \
        --webroot-path /vol/www/ \
        $CERTBOT_DOMAINS \
        --email $EMAIL \
        --rsa-key-size 4096 \
        --agree-tos \
        --non-interactive"

#    certbot certonly --webroot --webroot-path "/vol/www/" $CERTBOT_DOMAINS --email "$EMAIL" --rsa-key-size 4096 --agree-tos --non-interactive
else
    echo "No valid domains found to obtain certificates."
fi

