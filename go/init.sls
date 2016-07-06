{% from "go/map.jinja" import go with context %}

go:
  file.managed:
    - name: /opt/src/go{{ go.version }}.src.tar.gz
    - source: https://storage.googleapis.com/golang/go{{ go.version }}.src.tar.gz
    - source_hash: sha1={{ go.checksum }}
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf go{{ go.version }}.src.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: go

go-build:
  cmd.run:
    - cwd: /opt/src/go/src
    - name: ./all.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go
