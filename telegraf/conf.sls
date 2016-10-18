{% from "telegraf/map.jinja" import telegraf with context %}


include:
  - telegraf


telegraf-conf:
  file.managed:
    - name: {{ telegraf.conf }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://telegraf/files/telegraf.conf
    - require:
      - cmd: telegraf
