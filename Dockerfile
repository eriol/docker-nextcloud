FROM eriol/debian-i386:jessie
MAINTAINER Daniele Tricoli "eriol@mornie.org"

ENV LAST_UPDATE 2015-11-17
ENV OWNCLOUD_VERSION 8.2.0
ENV OWNCLOUD_SHA256SUM fcfe99cf1c3aa06ff369e5b1a602147c08dd977af11800fe06c6a661fa5f770c

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
    php5-sqlite && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2 /tmp/owncloud.tar.bz2
RUN sha256sum /tmp/owncloud.tar.bz2 | grep -q ${OWNCLOUD_SHA256SUM} && \
    tar -xf /tmp/owncloud.tar.bz2 -C /srv && \
    mkdir /srv/owncloud/data && \
    chown -R www-data:www-data /srv/owncloud && \
    rm /tmp/owncloud.tar.bz2

ADD owncloud.conf /etc/nginx/sites-available/owncloud.conf
RUN ln -s /etc/nginx/sites-available/owncloud.conf /etc/nginx/sites-enabled/ && \
    rm -f /etc/nginx/sites-enabled/default

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

ADD start.sh /start.sh

VOLUME ["/srv/owncloud/config", "/srv/owncloud/data"]

EXPOSE 80

ENTRYPOINT ["/start.sh"]
