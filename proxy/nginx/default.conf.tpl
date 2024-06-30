server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};

    if ($host !~* ^(www\.)?${DOMAIN}$) {
        return 444;
    }

    error_log  /var/log/nginx/error.log;
    access_log  /var/log/nginx/access.log;

    location /.well-known/acme-challenge/ {
        root /vol/www/;
    }

    location /static/ {
        alias /app/staticfiles/;
        add_header Access-Control-Allow-Origin *;
    }

    location /media/ {
        alias /app/media/;
        add_header Access-Control-Allow-Origin *;
    }

    location / {
        proxy_pass http://app:8000;
        include /etc/nginx/wsgi_params;
        client_max_body_size 10M;
    }
}
