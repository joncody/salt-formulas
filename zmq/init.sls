{% from "zmq/map.jinja" import zmq with context %}

include:
  - sodium

zmq:
  pkg.installed:
    - names:
      - asciidoc
      - liblz4-dev
      - libpcre3-dev
      - libpgm-dev
      - uuid-dev
    - require:
      - cmd: sodium
  git.latest:
    - name: {{ zmq.repo }}
    - branch: {{ zmq.branch }}
    - rev: {{ zmq.rev }}
    - target: /opt/src/libzmq
    - require:
      - pkg: zmq
  cmd.run:
    - cwd: /opt/src/libzmq
    - name: ./autogen.sh && LDFLAGS=-L/opt/sodium/lib CPPFLAGS=-I/opt/sodium/include ./configure --prefix=/opt/zmq --enable-debug --enable-valgrind --with-gnu-ld --with-libsodium --with-pgm && make && make install && make clean
    - unless: test -d /opt/zmq
    - require:
      - git: zmq
