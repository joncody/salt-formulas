{% from "conky/map.jinja" import conky with context %}

include:
  - conky

conky-conf:
  file.managed:
    - name: /etc/conky/conky.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://conky/files/conky.conf
    - makedirs: True
    - require:
      - pkg: conky
