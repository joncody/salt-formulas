{% from "conky/map.jinja" import conky with context %}

include:
  - optsrc

conky:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - autotools-dev
      - build-essential
      - cmake
      - curl
      - git
      - libcurl3
      - libcurl4-openssl-dev
      - libevent-dev
      - libglib2.0-dev
      - libimlib2-dev
      - libncurses5-dev
      - libssl-dev
      - libtool
      - libtolua-dev
      - libtolua++5.1-dev
      - libx11-dev
      - libxdamage-dev
      - libxft-dev
      - libxinerama-dev
      - libxml2-dev
      - openssl
      - pkg-config
      - valgrind
      - xfonts-terminus
    - require:
      - file: optsrc
  git.latest:
    - name: {{ conky.repo }}
    - branch: master
    - target: /opt/src/conky
    - require:
      - pkg: conky
  cmd.run:
    - name: mkdir -p build
    - cwd: /opt/src/conky
    - require:
      - git: conky

conky-build:
  cmd.run:
    - cwd: /opt/src/conky/build
    - name: cmake .. && make && make install && make clean
    - require:
      - cmd: conky
