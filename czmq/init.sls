{% from "czmq/map.jinja" import czmq with context %}

include:
  - zmq

czmq_deps:
  pkg.installed:
    - names:
      - build-essential
      - liblz4-dev
      - pkg-config
      - uuid-dev

czmq_git:
  git.latest:
    - name: {{ czmq.repo }}
    - branch: {{ czmq.branch }}
    - rev: {{ czmq.rev }}
    - target: /opt/src/czmq
    - require:
      - cmd: zmq_build
      - pkg: czmq_deps

czmq_build:
  cmd.run:
    - cwd: /opt/src/czmq
    - name: |
        ./autogen.sh
        ./configure --prefix={{ czmq.prefix }} --with-gnu-ld --with-libzmq=/opt/zmq --with-uuid --with-liblz4
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - env:
      - PKG_CONFIG_PATH: "/opt/zmq/lib/pkgconfig:/opt/zmq/lib64/pkgconfig"
      - LDFLAGS: "-L/opt/zmq/lib -L/opt/zmq/lib64"
      - CPPFLAGS: "-I/opt/zmq/include"
    - onchanges:
      - git: czmq_git
    - creates: {{ czmq.prefix }}/lib/libczmq.so
