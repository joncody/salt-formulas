{% from "opensmtpd/map.jinja" import opensmtpd with context %}

include:
  - opensmtpd

smtpd-conf:
  file.managed:
    - name: {{ opensmtpd.smtpd }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://opensmtpd/files/smtpd.conf
    - require:
      - cmd: opensmtpd

aliases-conf:
  file.managed:
    - name: {{ opensmtpd.aliases }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://opensmtpd/files/aliases
    - require:
      - file: smtpd-conf

domains-conf:
  file.managed:
    - name: {{ opensmtpd.domains }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://opensmtpd/files/domains
    - require:
      - file: aliases-conf

users-conf:
  file.managed:
    - name: {{ opensmtpd.users }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://opensmtpd/files/users
    - require:
      - file: domains-conf

vusers-conf:
  file.managed:
    - name: {{ opensmtpd.vusers }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://opensmtpd/files/vusers
    - require:
      - file: users-conf

secrets-conf:
  file.managed:
    - name: {{ opensmtpd.secrets }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://opensmtpd/files/secrets
    - require:
      - file: vusers-conf

crt-conf:
  file.managed:
    - name: {{ opensmtpd.crt }}
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - source: salt://opensmtpd/files/mail.crt
    - require:
      - file: secrets-conf

key-conf:
  file.managed:
    - name: {{ opensmtpd.key }}
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - source: salt://opensmtpd/files/mail.key
    - require:
      - file: crt-conf
