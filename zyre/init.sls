{% from "zyre/map.jinja" import zyre with context %}

include:
  - czmq

zyre_deps:
  pkg.installed:
    - names:
      - build-essential
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
      - PKG_CONFIG_PATH: "/opt/czmq/lib/pkgconfig:/opt/zmq/lib/pkgconfig"
      - LDFLAGS: "-L/opt/czmq/lib -L/opt/zmq/lib"
      - CPPFLAGS: "-I/opt/czmq/include -I/opt/zmq/include"
    - onchanges:
      - git: zyre_git
