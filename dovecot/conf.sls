{% from "dovecot/map.jinja" import dovecot with context %}

dovecot-conf:
  file.managed:
    - name: /opt/dovecot/etc/dovecot/dovecot.conf
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://dovecot/files/dovecot.conf
    - require:
      - cmd: dovecot_build

dovecot-ssl-dir:
  file.directory:
    - name: /opt/dovecot/etc/dovecot/ssl
    - user: root
    - group: root
    - mode: '0700'
    - makedirs: True
    - require:
      - file: dovecot-conf

dovecot-ssl:
  cmd.run:
    - cwd: /opt/dovecot/etc/dovecot/ssl
    - name: openssl req -x509 -nodes -days 365 -sha256 -subj '/C=US' -newkey rsa:4096 -keyout dovecot.key -out dovecot.crt && chmod 600 dovecot.key dovecot.crt
    - creates: /opt/dovecot/etc/dovecot/ssl/dovecot.key
    - require:
      - file: dovecot-ssl-dir

dovecot-dhparams:
  cmd.run:
    - cwd: /opt/dovecot/etc/dovecot/ssl
    - name: openssl dhparam 2048 -out dh_params.pem
    - creates: /opt/dovecot/etc/dovecot/ssl/dh_params.pem
    - require:
      - cmd: dovecot-ssl
