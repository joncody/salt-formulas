{% from "pureftpd/map.jinja" import pureftpd with context %}

include:
  - pureftpd

pureftpd-conf:
  file.managed:
    - name: /opt/pureftpd/etc/pure-ftpd.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://pureftpd/files/pure-ftpd.conf
    - require:
      - cmd: pureftpd

pureftpd-mkdir:
  cmd.run:
    - cwd: /opt/pureftpd/etc
    - name: mkdir -p ssl
    - require:
      - file: pureftpd-conf

pureftpd-ssl:
  cmd.run:
    - cwd: /opt/pureftpd/etc/ssl
    - name: openssl req -x509 -nodes -days 365 -sha256 -subj '/C=US' -newkey rsa:4096 -keyout pureftpd.pem -out pureftpd.pem && chmod 600 pureftpd.pem
    - unless: test -f /opt/pureftpd/etc/ssl/pureftpd.pem
    - require:
      - cmd: pureftpd-mkdir
