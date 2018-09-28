FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

ENTRYPOINT ["/entrypoint.sh"]

RUN cd /tmp/ \
  && apt-get update -qqy \
  && apt-get upgrade -qqy \
# локаль
  && apt-get install -yqq  --no-install-recommends --no-install-suggests locales apt-utils

# локаль
ENV LANG='ru_RU.UTF-8' LANGUAGE='ru_RU.UTF-8' LC_ALL='ru_RU.UTF-8'
RUN echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen && locale-gen

RUN export DEBIAN_FRONTEND='noninteractive' \
  && apt-get install --no-install-recommends -yqq wget gnupg2 \
##  && echo "deb http://download.bareos.org/bareos/release/latest/Debian_9.0/ ./" > /etc/apt/sources.list.d/bareos.list \
##  && wget -q http://download.bareos.org/bareos/release/latest/Debian_9.0/Release.key -O- | apt-key add - \
## Unofficial Bareos repository http://bareos.ring.lt/
  && echo "deb http://bareos.ring.lt stretch main" >> /etc/apt/sources.list \
  && wget -O - http://bareos.ring.lt/bareos.ring.lt.asc | apt-key add - \
  && apt-get update \
  && apt-get install --no-install-recommends -yqq bareos bareos-database-sqlite3 bareos-webui msmtp apache2 \
  && mv /etc/bareos /etc/bareos.orig \
  && mv /var/lib/bareos /var/lib/bareos.orig \
# replace sendmail
  && rm /usr/sbin/sendmail \
  && ln -s /usr/bin/msmtp /usr/sbin/sendmail \
##  msmtprc
  && rm -f /etc/msmtprc \
  && ln -sf /etc/bareos/msmtprc /etc/msmtprc \
  && apt-get autoremove -qqy \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* 

RUN export DEBIAN_FRONTEND='noninteractive' \
  && apt-get update -qqy \
  && apt-get install --no-install-recommends -yqq procps telnet


COPY [ "add/", "/" ]

