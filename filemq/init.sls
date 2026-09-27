{% from "filemq/map.jinja" import filemq with context %}

include:
  - czmq

filemq_deps:
  pkg.installed:
    - names:
      - build-essential
      - pkg-config

filemq_git:
  git.latest:
    - name: {{ filemq.repo }}
    - branch: {{ filemq.branch }}
    - rev: {{ filemq.branch }}
    - target: /opt/src/filemq
    - force_reset: True
    - require:
      - cmd: czmq_build
      - pkg: filemq_deps

filemq_build:
  cmd.run:
    - cwd: /opt/src/filemq
    - name: |
        ./autogen.sh
        ./configure --prefix={{ filemq.prefix }} --with-gnu-ld --with-libsodium=/opt/sodium --with-libzmq=/opt/zmq --with-libczmq=/opt/czmq
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - env:
      - PKG_CONFIG_PATH: "/opt/czmq/lib/pkgconfig:/opt/zmq/lib/pkgconfig:/opt/sodium/lib/pkgconfig"
      - LDFLAGS: "-L/opt/czmq/lib -L/opt/zmq/lib -L/opt/sodium/lib"
      - CPPFLAGS: "-I/opt/czmq/include -I/opt/zmq/include -I/opt/sodium/include"
    - onchanges:
      - git: filemq_git
