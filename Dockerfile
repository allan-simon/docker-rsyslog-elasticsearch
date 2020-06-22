FROM      ubuntu
# Install rsyslog and rsyslog-elasticsearch extensions. All in one
# go to reduce amount of layers.
RUN       apt-get -y update && \
          apt-get upgrade -y --no-install-recommends && \
          apt-get install -y --no-install-recommends \
          software-properties-common && \
          apt-get -y update && \
          apt-get -q -y --no-install-recommends install \
          rsyslog rsyslog-elasticsearch cron logrotate && \
          apt-get clean && \
          rm -rf /var/lib/apt/lists/* && \
          chown syslog /var/log

COPY      entrypoint.sh                  /
COPY	  rsyslog.conf                   /etc/
COPY      rsyslog_elasticsearch.conf     /etc/rsyslog.d/
COPY      rsyslog-rotate                 /usr/lib/rsyslog/rsyslog-rotate

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-n"]
