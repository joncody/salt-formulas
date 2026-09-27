{% from "zmq/map.jinja" import zmq with context %}

include:
  - sodium

zmq_deps:
  pkg.installed:
    - names:
      - asciidoc
      - liblz4-dev
      - libpgm-dev
      - pkg-config
      - uuid-dev
    - require:
      - cmd: sodium_build

zmq_git:
  git.latest:
    - name: {{ zmq.repo }}
    - rev: v{{ zmq.version }}
    - target: /opt/src/libzmq
    - force_reset: True
    - require:
      - pkg: zmq_deps

zmq_build:
  cmd.run:
    - cwd: /opt/src/libzmq
    - name: |
        ./autogen.sh
        ./configure --prefix={{ zmq.prefix }} --enable-debug --with-gnu-ld --with-libsodium --with-pgm
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - env:
      - PKG_CONFIG_PATH: "/opt/sodium/lib/pkgconfig:/opt/sodium/lib64/pkgconfig"
      - LDFLAGS: "-L/opt/sodium/lib -L/opt/sodium/lib64"
      - CPPFLAGS: "-I/opt/sodium/include"
    - onchanges:
      - git: zmq_git
