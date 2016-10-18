{% from "influxdb/map.jinja" import influxdb with context %}


include:
  - influxdb


influxdb-conf:
  file.managed:
    - name: {{ influxdb.conf }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://influxdb/files/influxdb.conf
    - require:
      - cmd: influxdb
