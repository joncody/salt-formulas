{% from "dovecot/map.jinja" import dovecot with context %}

include:
  - dovecot

dovecot-conf:
  file.managed:
    - name: /opt/dovecot/etc/dovecot/dovecot.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://dovecot/files/dovecot.conf
    - require:
      - cmd: dovecot-install

dovecot-mkdir:
  cmd.run:
    - cwd: /opt/dovecot/etc/dovecot
    - name: mkdir ssl
    - require:
      - file: dovecot-conf

dovecot-ssl:
  cmd.run:
    - cwd: /opt/dovecot/etc/dovecot/ssl
    - name: openssl req -x509 -nodes -days 365 -sha256 -subj '/C=US' -newkey rsa:4096 -keyout dovecot.key -out dovecot.crt
    - require:
      - cmd: dovecot-mkdir

dovecot-dhparams:
  cmd.run:
    - cwd: /opt/dovecot/etc/dovecot/ssl
    - name: openssl dhparam 4096 -out dh_params.pem
    - require:
      - cmd: dovecot-ssl
