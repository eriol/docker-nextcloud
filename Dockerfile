FROM eriol/debian-i386:jessie
MAINTAINER Daniele Tricoli "eriol@mornie.org"

ENV LAST_UPDATE 2018-02-12
ENV NEXTCLOUD_VERSION 13.0.0
ENV NEXTCLOUD_SHA256SUM 38e6064432a2d1a044f219028d3fd46cb7a943a47e11eef346810bd289705aec

RUN apt-get update && apt-get -y --no-install-recommends install \
    bzip2 \
    ca-certificates \
    cron \
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

ADD https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2 /tmp/nextcloud.tar.bz2
RUN sha256sum /tmp/nextcloud.tar.bz2 | grep -q ${NEXTCLOUD_SHA256SUM} && \
    tar -xf /tmp/nextcloud.tar.bz2 -C /srv && \
    mkdir /srv/nextcloud/data && \
    chown -R www-data:www-data /srv/nextcloud && \
    rm /tmp/nextcloud.tar.bz2

ADD nextcloud.conf /etc/nginx/sites-available/nextcloud.conf
RUN ln -s /etc/nginx/sites-available/nextcloud.conf /etc/nginx/sites-enabled/ && \
    rm -f /etc/nginx/sites-enabled/default

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

ADD crontab /etc/cron.d/nextcloud

ADD start.sh /start.sh

VOLUME ["/srv/nextcloud/config", "/srv/nextcloud/data"]

EXPOSE 80

ENTRYPOINT ["/start.sh"]
