{% from "go/map.jinja" import go with context %}

include:
  - optsrc

go_dir:
  file.directory:
    - name: {{ go.prefix }}
    - user: root
    - group: root
    - dir_mode: '1777'
    - makedirs: True

go_archive:
  archive.extracted:
    - name: {{ go.prefix }}
    - source: https://go.dev/dl/go{{ go.version }}.linux-amd64.tar.gz
    - skip_verify: True
    - archive_format: tar
    - options: "--strip-components=1"
    - enforce_ownership_on: {{ go.prefix }}
    - creates: {{ go.prefix }}/bin/go
    - require:
      - file: go_dir
