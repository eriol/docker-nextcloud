# docker-owncloud #

Docker i386 image with ownCloud and nginx. It uses SQLite as database because
it is intended for personal use only (one user). It also uses two docker
volumes, one for config and one for data.

## Build ##

```
    docker build -t 'yourusername/owncloud' .
```
## Run ##

```shell
    docker run -d -p 127.0.0.1:9000:80 --name owncloud \
    -v /srv/owncloud/config:/srv/owncloud/config \
    -v /srv/owncloud/data:/srv/owncloud/data eriol/owncloud
```

You should use nginx on the host as reverse proxy::

```
    server {
       listen 80;
       server_name owncloud.example.org;
       return 301 https://$host$request_uri;
    }

    server {
       listen 443;
       server_name owncloud.example.com;

       ssl on;
       ssl_certificate /etc/ssl/private/example_org.cert;
       ssl_certificate_key /etc/ssl/private/example_org.key;

       location / {
          proxy_pass http://127.0.0.1:9000;
          proxy_redirect off;
          proxy_buffering off;
          proxy_set_header    Host    $host;
          proxy_set_header    X-Real-IP   $remote_addr;
          proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
       }
    }
```
