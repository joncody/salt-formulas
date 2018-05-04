{% from "zyre/map.jinja" import zyre with context %}

include:
  - czmq

zyre:
  git.latest:
    - name: {{ zyre.repo }}
    - branch: {{ zyre.branch }}
    - rev: {{ zyre.rev }}
    - target: /opt/src/zyre
    - require:
      - cmd: czmq
  cmd.run:
    - cwd: /opt/src/zyre
    - name: ./autogen.sh && ./configure --prefix=/opt/zyre --with-gnu-ld --with-libzmq=/opt/zmq --with-libczmq=/opt/czmq --with-docs && make && make install && make clean
    - unless: test -d /opt/zyre
    - require:
      - git: zyre
