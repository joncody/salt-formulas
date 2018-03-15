{% from "filemq/map.jinja" import filemq with context %}

include:
  - czmq

filemq:
  git.latest:
    - name: {{ filemq.repo }}
    - branch: master
    - target: /opt/src/filemq
    - require:
      - cmd: czmq
  cmd.run:
    - cwd: /opt/src/filemq
    - name: ./autogen.sh && ./configure --prefix=/opt/filemq --with-gnu-ld --with-libsodium=/opt/sodium --with-libzmq=/opt/zmq --with-libczmq=/opt/czmq --with-docs && make && make install && make clean
    - unless: test -d /opt/filemq
    - require:
      - git: filemq
