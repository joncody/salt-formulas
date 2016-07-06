{% from "rsyslog/map.jinja" import rsyslog with context %}

include:
  - rsyslog

rsyslog-conf:
  file.managed:
    - name: {{ rsyslog.conf }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://rsyslog/files/rsyslog.conf
    - require:
      - cmd: rsyslog-build
