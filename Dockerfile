FROM blacklabelops/centos:7.2.1511
MAINTAINER Steffen Bleul <blacklabelops@itbleul.de>

# install rsnapshot
COPY configuration/rsnapshot.conf /etc/rsnapshot.conf
COPY imagescripts/docker-entrypoint.sh /usr/bin/rsnapshot.d/docker-entrypoint.sh
COPY imagescripts/rsnapshot.sh /usr/bin/rsnapshot.d/rsnapshot.sh

RUN yum install -y epel-release && \
    yum install -y rsnapshot-1.3.1 && \
    yum clean all && rm -rf /var/cache/yum/* && \
    mkdir -p /usr/bin/rsnapshot.d && \
    cp /etc/rsnapshot.conf /usr/bin/rsnapshot.d/rsnapshot.conf && \
    chmod ug+x /usr/bin/rsnapshot.d/*.sh

ENV BACKUP_INTERVAL= \
    BACKUP_DIRECTORIES= \
    DELAYED_START= \
    RSNAPSHOT_HOURLY_TIMES= \
    RSNAPSHOT_DAILY_TIMES= \
    RSNAPSHOT_WEEKLY_TIMES= \
    RSNAPSHOT_MONTHLY_TIMES= \
    VOLUME_DIRECTORY=/snapshots

ENTRYPOINT ["/usr/bin/rsnapshot.d/docker-entrypoint.sh"]
VOLUME ["${VOLUME_DIRECTORY}"]
CMD ["rsnapshot"]
