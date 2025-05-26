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
    - name: openssl req -x509 -nodes -days 365 -sha256 -subj '/C=US' -newkey rsa:4096 -keyout opensmtpd.key -out opensmtpd.crt && chmod 600 opensmtpd.key opensmtpd.crt
    - unless: test -f /opt/opensmtpd/etc/ssl/opensmtpd.key && test -f /opt/opensmtpd/etc/ssl/opensmtpd.crt
    - require:
      - cmd: opensmtpd-mkdir

opensmtpd-aliases:
  file.managed:
    - name: /opt/opensmtpd/etc/aliases
    - makedirs: True
    - create: True
    - user: root
    - group: root
    - dir_mode: 755
    - mode: 644
    - contents:
      - vmail:    /dev/null
      - root:     root
    - require:
      - cmd: opensmtpd-ssl

opensmtpd-domains:
  file.managed:
    - name: /opt/opensmtpd/etc/domains
    - makedirs: True
    - create: True
    - user: root
    - group: root
    - dir_mode: 755
    - mode: 644
    - require:
      - file: opensmtpd-aliases

opensmtpd-passwd:
  file.managed:
    - name: /opt/opensmtpd/etc/passwd
    - makedirs: True
    - create: True
    - user: root
    - group: root
    - dir_mode: 755
    - mode: 644
    - require:
      - file: opensmtpd-domains

opensmtpd-vusers:
  file.managed:
    - name: /opt/opensmtpd/etc/vusers
    - makedirs: True
    - create: True
    - user: root
    - group: root
    - dir_mode: 755
    - mode: 644
    - require:
      - file: opensmtpd-passwd
