{% from "opensmtpd/map.jinja" import opensmtpd with context %}

opensmtpd-conf:
  file.managed:
    - name: /opt/opensmtpd/etc/smtpd.conf
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - source: salt://opensmtpd/files/smtpd.conf
    - require:
      - cmd: opensmtpd_build

opensmtpd-ssl-dir:
  file.directory:
    - name: /opt/opensmtpd/etc/ssl
    - user: root
    - group: root
    - mode: '0700'
    - makedirs: True
    - require:
      - file: opensmtpd-conf

opensmtpd-ssl:
  cmd.run:
    - cwd: /opt/opensmtpd/etc/ssl
    - name: openssl req -x509 -nodes -days 365 -sha256 -subj '/C=US' -newkey rsa:4096 -keyout opensmtpd.key -out opensmtpd.crt && chmod 600 opensmtpd.key opensmtpd.crt
    - creates: /opt/opensmtpd/etc/ssl/opensmtpd.key
    - require:
      - file: opensmtpd-ssl-dir

opensmtpd-aliases:
  file.managed:
    - name: /opt/opensmtpd/etc/aliases
    - makedirs: True
    - create: True
    - user: root
    - group: root
    - mode: '0644'
    - contents:
      - vmail:    /dev/null
      - root:     root
    - require:
      - cmd: opensmtpd-ssl
