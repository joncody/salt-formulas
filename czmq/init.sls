{% from "czmq/map.jinja" import czmq with context %}

include:
  - zmq

czmq_deps:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - build-essential
      - liblz4-dev
      - libtool
      - pkg-config
      - uuid-dev

czmq_git:
  git.latest:
    - name: {{ czmq.repo }}
    - rev: v{{ czmq.version }}
    - target: /opt/src/czmq
    - force_reset: True
    - require:
      - cmd: zmq_build
      - pkg: czmq_deps

czmq_build:
  cmd.run:
    - cwd: /opt/src/czmq
    - name: |
        ./autogen.sh
        ./configure --prefix={{ czmq.prefix }} --with-gnu-ld --with-libzmq=/opt/zmq --with-libsodium=/opt/sodium --with-uuid --with-liblz4
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - env:
      - PKG_CONFIG_PATH: "/opt/zmq/lib/pkgconfig:/opt/sodium/lib/pkgconfig"
      - LDFLAGS: "-L/opt/zmq/lib -L/opt/sodium/lib"
      - CPPFLAGS: "-I/opt/zmq/include -I/opt/sodium/include"
      - LD_LIBRARY_PATH: "/opt/zmq/lib:/opt/sodium/lib"
    - onchanges:
      - git: czmq_git
