{% from "zmq/map.jinja" import zmq with context %}

include:
  - sodium

zmq:
  pkg.installed:
    - names:
      - git
      - build-essential
      - libtool
      - pkg-config
      - autotools-dev
      - autoconf
      - automake
      - cmake
      - uuid-dev
      - libpcre3-dev
      - valgrind
      - asciidoc
      - liblz4-dev
      - libpgm-dev
    - require:
      - cmd: sodium
  git.latest:
    - name: {{ zmq.repo }}
    - branch: master
    - target: /opt/src/libzmq
    - require:
      - pkg: zmq
  cmd.run:
    - cwd: /opt/src/libzmq
    - name: ./autogen.sh && LDFLAGS=-L/opt/sodium/lib CPPFLAGS=-I/opt/sodium/include ./configure --prefix=/opt/zmq --enable-debug --enable-valgrind --with-gnu-ld --with-libsodium --with-pgm && make && make install && make clean && ldconfig && source /etc/profile
    - unless: test -d /opt/zmq
    - require:
      - git: zmq
