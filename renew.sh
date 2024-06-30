#!/bin/sh
set -e

cd QuarnAPIServer
/usr/local/bin/docker compose run --rm certbot certbot renew