#!/bin/bash

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
	sed s/myserver.local/$ESLOG_HOST/g -i /etc/rsyslog.d/rsyslog_elasticsearch.conf
	if [ -n "$ESLOG_ES_PORT" ]; then
		sed s/9200/$ESLOG_ES_PORT/g -i /etc/rsyslog.d/rsyslog_elasticsearch.conf
	fi
	if [ -n "$ESLOG_ES_USE_HTTPS" ]; then
		sed s/usehttps=\"on\"/$ESLOG_ES_USE_HTTPS/g -i /etc/rsyslog.d/rsyslog_elasticsearch.conf
	fi
fi

/usr/sbin/rsyslogd $@
