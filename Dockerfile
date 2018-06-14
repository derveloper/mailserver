FROM hardware/debian-mail-overlay:latest

LABEL description "Simple and full-featured mail server using Docker" \
      maintainer="Hardware <contact@meshup.net>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install wget -y -q --no-install-recommends

RUN echo "deb http://xi.dovecot.fi/debian/ stable-auto/dovecot-2.3 main" >> /etc/apt/sources.list

RUN wget http://xi.dovecot.fi/debian/archive.key
RUN apt-key add archive.key && rm archive.key

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    dovecot-core=2:2.3.2~alpha0-1~auto+47 dovecot-imapd=2:2.3.2~alpha0-1~auto+47 dovecot-lmtpd=2:2.3.2~alpha0-1~auto+47  dovecot-pgsql=2:2.3.2~alpha0-1~auto+47  dovecot-mysql=2:2.3.2~alpha0-1~auto+47  dovecot-sieve=2:2.3.2~alpha0-1~auto+47  dovecot-managesieved=2:2.3.2~alpha0-1~auto+47  dovecot-pop3d=2:2.3.2~alpha0-1~auto+47

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    postfix postfix-pgsql postfix-mysql postfix-pcre libsasl2-modules \
    fetchmail libdbi-perl libdbd-pg-perl libdbd-mysql-perl liblockfile-simple-perl \
    clamav clamav-daemon \
    python-setuptools python-gpgme \
    rsyslog dnsutils curl unbound jq rsync \
 && rm -rf /var/spool/postfix \
 && ln -s /var/mail/postfix/spool /var/spool/postfix \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/debconf/*-old

EXPOSE 25 143 465 587 993 4190 11334
COPY rootfs /
RUN chmod +x /usr/local/bin /services/*/run /services/.s6-svscan/finish
CMD ["run.sh"]
