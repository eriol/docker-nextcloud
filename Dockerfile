FROM eriol/debian-i386:jessie
MAINTAINER Daniele Tricoli "eriol@mornie.org"
ENV LAST_UPDATE 2015-02-15

RUN apt-get update && apt-get -y --no-install-recommends install \
    nginx \
    owncloud \
    php5-fpm \
    php5-sqlite

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/nginx/sites-enabled/default
ADD owncloud.conf /etc/nginx/sites-available/owncloud.conf
RUN ln -s /etc/nginx/sites-available/owncloud.conf /etc/nginx/sites-enabled/

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ADD start.sh /start.sh

VOLUME ["/usr/share/owncloud/data"]

EXPOSE 80

ENTRYPOINT ["/start.sh"]
