{% from "conky/map.jinja" import conky with context %}

include:
  - optsrc

conky:
  pkg.installed:
    - names:
      - cmake
      - libimlib2-dev
      - libtolua-dev
      - libtolua++5.1-dev
      - libx11-dev
      - libxft-dev
      - libxdamage-dev
      - libncurses5-dev
      - libxinerama-dev
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
