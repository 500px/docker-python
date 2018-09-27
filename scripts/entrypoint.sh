#!/bin/bash

eval $(kms-env decrypt)

if [[ -n $DATADOG_ENABLE ]]; then
    envsubst < /opt/templates/datadog.conf.tmpl > /etc/dd-agent/datadog.conf
    mkdir -p /var/log/datadog
    chown dd-agent:dd-agent /var/log/datadog
    /etc/init.d/datadog-agent start
fi

exec "$@"
