{% from "go/map.jinja" import go with context %}


go_deps:
  pkg.installed:
    - names:
      - build-essential
  file.directory:
    - name: /opt/src
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - require:
      - pkg: go_deps

go1_4:
  file.managed:
    - name: /opt/src/go1.4.3.src.tar.gz
    - source: https://storage.googleapis.com/golang/go1.4.3.src.tar.gz
    - source_hash: sha1=486db10dc571a55c8d795365070f66d343458c48
    - require:
      - file: go_deps
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf go1.4.3.src.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: go1_4

go1_4-build:
  cmd.run:
    - cwd: /opt/src/go/src
    - name: CGO_ENABLED=0 ./make.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go1_4

go1_4-rename:
  cmd.run:
    - cwd: /opt/src
    - name: mv /opt/src/go /opt/src/go1.4.3
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go1_4-build

go:
  file.managed:
    - name: /opt/src/go{{ go.version }}.src.tar.gz
    - source: https://storage.googleapis.com/golang/go{{ go.version }}.src.tar.gz
    - source_hash: sha256={{ go.checksum }}
    - require:
      - cmd: go1_4-rename
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
    - name: GOROOT_BOOTSTRAP=/opt/src/go1.4.3 ./make.bash
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: go
