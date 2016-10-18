{% from "telegraf/map.jinja" import telegraf with context %}


telegraf_deps:
  file.directory:
    - name: /opt/src
    - user: root
    - group: root
    - mode: 755
    - makedirs: True


telegraf:
  file.managed:
    - name: /opt/src/telegraf_{{ telegraf.version }}_amd64.deb
    - source: https://dl.influxdata.com/telegraf/releases/telegraf_{{ telegraf.version }}_amd64.deb
    - source_hash: md5={{ telegraf.checksum }}
    - require:
      - file: telegraf_deps
  cmd.run:
    - cwd: /opt/src
    - name: dpkg -i telegraf_{{ telegraf.version }}_amd64.deb
    - runas: root
    - require:
      - file: telegraf
