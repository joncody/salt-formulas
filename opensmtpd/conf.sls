{% from "opensmtpd/map.jinja" import opensmtpd with context %}

include:
  - opensmtpd

opensmtpd-conf:
  file.managed:
    - name: /opt/opensmtpd/etc/smtpd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://opensmtpd/files/smtpd.conf
    - require:
      - cmd: opensmtpd

opensmtpd-mkdir:
  cmd.run:
    - cwd: /opt/opensmtpd/etc
    - name: mkdir -p ssl
    - require:
      - file: opensmtpd-conf

opensmtpd-ssl:
  cmd.run:
    - cwd: /opt/opensmtpd/etc/ssl
    - name: openssl req -x509 -nodes -days 365 -sha256 -subj '/C=US' -newkey rsa:4096 -keyout opensmtpd.key -out opensmtpd.crt
    - unless: test -f /opt/opensmtpd/etc/ssl/opensmtpd.key && test -f /opt/opensmtpd/etc/ssl/opensmtpd.crt
    - require:
      - cmd: opensmtpd-mkdir

opensmtpd-files:
  cmd.run:
    - cwd: /opt/opensmtpd/etc
    - name: printf "vmail:    /dev/null\r\nroot:     root" > aliases && touch {domains,passwd,vusers}
    - unless: test -f /opt/opensmtpd/etc/aliases && test -f /opt/opensmtpd/etc/domains && test -f /opt/opensmtpd/etc/passwd && test -f /opt/opensmtpd/etc/vusers
    - require:
      - cmd: opensmtpd-ssl
