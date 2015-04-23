FROM eriol/debian-i386:jessie
MAINTAINER Daniele Tricoli "eriol@mornie.org"

ENV LAST_UPDATE 2015-04-23
ENV OWNCLOUD_VERSION 8.0.2
ENV OWNCLOUD_SHA256SUM 46c73b6ae3841e856d139537d21e1c7029c64d79fd7c45c794e27cb1469d7f01

RUN apt-get update && apt-get -y --no-install-recommends install \
    bzip2 \
    ca-certificates \
    nginx \
    php5 \
    php5-apcu \
    php5-curl \
    php5-fpm \
    php5-gd \
    php5-imagick \
    php5-intl \
    php5-json \
    php5-mcrypt \
    php5-sqlite
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2 /tmp/owncloud.tar.bz2
RUN sha256sum /tmp/owncloud.tar.bz2 | grep -q ${OWNCLOUD_SHA256SUM} && \
    tar -xf /tmp/owncloud.tar.bz2 -C /srv && \
    mkdir /srv/owncloud/data && \
    chown -R www-data:www-data /srv/owncloud && \
    rm /tmp/owncloud.tar.bz2

RUN rm -f /etc/nginx/sites-enabled/default
ADD owncloud.conf /etc/nginx/sites-available/owncloud.conf
RUN ln -s /etc/nginx/sites-available/owncloud.conf /etc/nginx/sites-enabled/

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ADD start.sh /start.sh

VOLUME ["/srv/owncloud/config", "/srv/owncloud/data"]

EXPOSE 80

ENTRYPOINT ["/start.sh"]
