{% from "node/map.jinja" import node with context %}

node:
  file.managed:
    - name: /opt/src/node-v{{ node.version }}.tar.gz
    - source: https://nodejs.org/dist/v{{ node.version }}/node-v{{ node.version }}.tar.gz
    - source_hash: sha256={{ node.checksum }}
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf node-v{{ node.version }}.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: node

node-build:
  cmd.run:
    - cwd: /opt/src/node-v{{ node.version }}
    - name: ./configure --prefix=/opt/node && make check install clean
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: node
