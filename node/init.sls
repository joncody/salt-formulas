{% from "node/map.jinja" import node with context %}

include:
  - optsrc

node:
  git.latest;
    - name: {{ node.repo }}
    - branch: master
    - target: /opt/src/node
    - require:
      - file: optsrc
  cmd.run:
    - cwd: /opt/src/node
    - name: ./configure --prefix=/opt/node --debug --gdb && make && make install && make clean && ldconfig && source /etc/profile
    - require:
      - git: node
