#!/bin/bash
set -e

# если папка с конфигами пуста
if [[  -z "`ls /etc/bareos`" ]]; then
  cp -pR /etc/bareos.orig/* /etc/bareos
  mkdir -p "/var/lib/bareos/bsr"
fi

# если папка с конфигами /etc/bareos-webui пуста
if [[  -z "`ls /etc/bareos-webui`" ]]; then
  cp -pR /etc/bareos-webui.orig/* /etc/bareos-webui
  mkdir -p "/var/lib/bareos/bsr"
fi

## пароль bareos-webui
[ ! -f /etc/bareos/bareos-dir.d/console/admin.conf ] && cp /etc/bareos/bareos-dir.d/console/admin.conf.example /etc/bareos/bareos-dir.d/console/admin.conf

##
[  -z "`ls /var/lib/bareos`" ] && mkdir -p /var/lib/bareos && cp -vpR /var/lib/bareos.orig/* /var/lib/bareos/

[ -f /var/lib/bareos/bareos-dir.9101.pid ] && rm /var/lib/bareos/bareos-dir*pid
[ -f /var/lib/bareos/bareos-dir.9101.pid ] && rm /var/lib/bareos/bareos-fd*pid

[ ! -f /etc/bareos/msmtprc ] && cp /opt/msmtprc.default /etc/bareos/msmtprc

# timezone
if [ ! -z "$TZ" ];
then
  echo "Set timezone to $TZ";
  sed -i -e "s|;date.timezone =*|date.timezone = $TZ |"           /etc/php/7.0/apache2/php.ini
fi

echo "2 0 * * * service bareos-fd restart" >> /var/spool/cron/crontabs/root

chown -R bareos /etc/bareos/ /var/log/bareos/ /var/lib/bareos/

service apache2 start && echo "  Start apache2"
service bareos-dir start && echo "  Start bareos-dir"
service bareos-fd start && echo "  Start bareos-fd"

wait
sleep infinity

