{% from "node/map.jinja" import node with context %}

include:
  - optsrc

node_dir:
  file.directory:
    - name: {{ node.prefix }}
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

node_archive:
  archive.extracted:
    - name: {{ node.prefix }}
    - source: https://nodejs.org/dist/v{{ node.version }}/node-v{{ node.version }}-linux-x64.tar.xz
    - skip_verify: True
    - archive_format: tar
    - options: "--strip-components=1"
    - enforce_ownership_on: {{ node.prefix }}
    - creates: {{ node.prefix }}/bin/node
    - require:
      - file: node_dir
