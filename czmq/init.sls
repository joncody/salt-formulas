{% from "czmq/map.jinja" import czmq with context %}

include:
  - zmq

czmq:
  git.latest:
    - name: {{ czmq.repo }}
    - branch: {{ czmq.branch }}
    - rev: {{ czmq.rev }}
    - target: /opt/src/czmq
    - require:
      - cmd: zmq
  cmd.run:
    - cwd: /opt/src/czmq
    - name: ./autogen.sh && ./configure --prefix=/opt/czmq --with-gnu-ld --with-libzmq=/opt/zmq --with-uuid --with-liblz4 --with-docs && make && make install && make clean
    - unless: test -d /opt/czmq
    - require:
      - git: czmq
