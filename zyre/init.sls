{% from "zyre/map.jinja" import zyre with context %}

include:
  - czmq

zyre_deps:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - build-essential
      - libtool
      - pkg-config

zyre_git:
  git.latest:
    - name: {{ zyre.repo }}
    - rev: v{{ zyre.version }}
    - target: /opt/src/zyre
    - force_reset: True
    - require:
      - cmd: czmq_build
      - pkg: zyre_deps

zyre_build:
  cmd.run:
    - cwd: /opt/src/zyre
    - name: |
        ./autogen.sh
        ./configure --prefix={{ zyre.prefix }} --with-gnu-ld --with-libzmq=/opt/zmq --with-libczmq=/opt/czmq
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - env:
      - PKG_CONFIG_PATH: "/opt/czmq/lib/pkgconfig:/opt/zmq/lib/pkgconfig:/opt/sodium/lib/pkgconfig"
      - LDFLAGS: "-L/opt/czmq/lib -L/opt/zmq/lib -L/opt/sodium/lib"
      - CPPFLAGS: "-I/opt/czmq/include -I/opt/zmq/include -I/opt/sodium/include"
      - LD_LIBRARY_PATH: "/opt/czmq/lib:/opt/zmq/lib:/opt/sodium/lib"
    - onchanges:
      - git: zyre_git
