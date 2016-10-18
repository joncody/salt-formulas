{% from "influxdb/map.jinja" import influxdb with context %}


influxdb_deps:
  file.directory:
    - name: /opt/src
    - user: root
    - group: root
    - mode: 755
    - makedirs: True


influxdb:
  file.managed:
    - name: /opt/src/influxdb_{{ influxdb.version }}_amd64.deb
    - source: https://dl.influxdata.com/influxdb/releases/influxdb_{{ influxdb.version }}_amd64.deb
    - source_hash: md5={{ influxdb.checksum }}
    - require:
      - file: influxdb_deps
  cmd.run:
    - cwd: /opt/src
    - name: dpkg -i influxdb_{{ influxdb.version }}_amd64.deb
    - runas: root
    - require:
      - file: influxdb
