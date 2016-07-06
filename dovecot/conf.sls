{% from "dovecot/map.jinja" import dovecot with context %}

include:
  - dovecot

dovecot-conf:
  file.managed:
    - name: {{ dovecot.conf }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://dovecot/files/dovecot.conf
    - require:
      - cmd: dovecot-build

dovecot-passwd:
  file.managed:
    - name: {{ dovecot.passwd }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://dovecot/files/passwd
    - require:
      - file: dovecot-conf

dovecot-crt:
  file.managed:
    - name: {{ dovecot.crt }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://dovecot/files/dovecot.crt
    - require:
      - file: dovecot-passwd

dovecot-key:
  file.managed:
    - name: {{ dovecot.key }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://dovecot/files/dovecot.key
    - require:
      - file: dovecot-crt
