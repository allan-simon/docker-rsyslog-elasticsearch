#!/bin/bash

set -e

# Also supports Maestro-ng formatted environment variables
 
if [ -z "$ESLOG_HOST" ]; then
	if [ -n "$ELASTICSEARCH_ESLOG1_HOST" ]; then
		ESLOG_HOST=`echo "$ELASTICSEARCH_ESLOG1_HOST"`
	fi
fi

if [ -z "$ESLOG_ES_PORT" ]; then
	if [ -n "$ELASTICSEARCH_ESLOG1_ES_PORT" ]; then
		ESLOG_ES_PORT=`echo "$ELASTICSEARCH_ESLOG1_ES_PORT"`
	fi
fi

if [ -n "$ESLOG_HOST" ]; then
	sed "s/myserver.local/$ESLOG_HOST/g" -i /etc/rsyslog.d/rsyslog_elasticsearch.conf
	if [ -n "$ESLOG_ES_PORT" ]; then
		sed "s/serverport=\"9200\"/serverport=\"$ESLOG_ES_PORT\"/g" -i /etc/rsyslog.d/rsyslog_elasticsearch.conf
	fi
	if [ -n "$ESLOG_ES_USE_HTTPS" ]; then
		sed s/usehttps=\"on\"/usehttps=\"$ESLOG_ES_USE_HTTPS\"/g -i /etc/rsyslog.d/rsyslog_elasticsearch.conf
	fi
fi

# we start cron, so that logrotate is launched daily (see /etc/cron.daily/logrotate)
service cron start

# we make sure there's no PID file remaining, which may happen if you manually restart the docker container 
rm -f /var/run/rsyslogd.pid

/usr/sbin/rsyslogd $@
