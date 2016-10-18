{% from "node/map.jinja" import node with context %}

node_deps:
  pkg.installed:
    - names:
      - build-essential
  file.directory:
    - name: /opt/src
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require:
      - pkg: node_deps

node:
  file.managed:
    - name: /opt/src/node-v{{ node.version }}.tar.gz
    - source: https://nodejs.org/dist/v{{ node.version }}/node-v{{ node.version }}.tar.gz
    - source_hash: sha256={{ node.checksum }}
    - require:
      - file: node_deps
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf node-v{{ node.version }}.tar.gz
    - require:
      - file: node

node-configure:
  cmd.run:
    - cwd: /opt/src/node-v{{ node.version }}
    - name: ./configure --prefix=/opt/node
    - require:
      - cmd: node

node-make:
  cmd.run:
    - cwd: /opt/src/node-v{{ node.version }}
    - name: make
    - require:
      - cmd: node-configure

node-install:
  cmd.run:
    - cwd: /opt/src/node-v{{ node.version }}
    - name: make install
    - require:
      - cmd: node-make
