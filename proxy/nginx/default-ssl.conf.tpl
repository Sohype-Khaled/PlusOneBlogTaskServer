server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};

    location /.well-known/acme-challenge/ {
        root /vol/www/;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen      443 ssl;
    server_name ${DOMAIN} www.${DOMAIN};

    if ($host !~* ^(www\.)?${DOMAIN}$) {
        return 444;
    }

    ssl_certificate     /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;

    include     /etc/nginx/options-ssl-nginx.conf;

    ssl_dhparam /vol/proxy/ssl-dhparams.pem;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location /static/ {
        alias /app/staticfiles/;
        add_header Access-Control-Allow-Origin *;
        expires max;
        access_log off;
        add_header Cache-Control "public";
    }

    location /media/ {
        alias /app/media/;
        add_header Access-Control-Allow-Origin *;
        expires max;
        access_log off;
        add_header Cache-Control "public";
    }

    location / {
        proxy_pass http://app:8000;
        include /etc/nginx/wsgi_params;
        client_max_body_size 10M;
        proxy_ssl_server_name on;
    }
}