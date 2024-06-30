## Deploy Steps
1. clone repo

2. copy `.env.example` to `.env`

3. set `.env` values

4. fresh installation
```
    docker compose up --build -d

    docker compose run --rm app bash -c "python manage.py collectstatic --no-input --clear"
    
    docker compose run --rm certbot /opt/certify-init.sh

    docker compose down
    
    docker compose up    
```

5. Handling SSL renewals
```
docker compose run --rm certbot sh -c "certbot renew"
```

6. Automatic SSL renwwals
    * create file `renew.sh` in home directory
        ```
            #!/bin/sh
            set -e
            
            cd project/path
            /usr/local/bin/docker compose run --rm certbot certbot renew
        ```
    * Then, run `chmod +x renew.sh` to make it executable. Then run:
        ```
            crontab -e
        ```
    * Then add the following:
        ```
            0 0 * * 6 sh /path/to/renew.sh
        ```

#### ref:
* Docker reference:
  * https://londonappdeveloper.com/django-docker-deployment-with-https-using-letsencrypt/


