FROM nimmis/alpine-micro

MAINTAINER nimmis <kjell.havneskold@gmail.com>

COPY root/. /
COPY start_vsftpd.sh /bin/start_vsftpd.sh

RUN apk update && apk -U upgrade -a && \

    # Make info file about this build
    printf "Build of nimmis/alpine-apache, date: %s\n"  `date -u +"%Y-%m-%dT%H:%M:%SZ"` >> /etc/BUILD && \

    apk add apache2 libxml2-dev apache2-utils vsftpd && \
    mkdir /web/ && chown -R apache.www-data /web && \

    sed -i 's#PidFile "/run/.*#Pidfile "/web/run/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf && \

    sed -i 's#/var/log/apache2/#/web/logs/#g' /etc/logrotate.d/apache2 && \

    rm -rf /var/cache/apk/*

VOLUME /web

EXPOSE 80 443 21 21000-21010

#CMD /bin/start_vsftpd.sh
