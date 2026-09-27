{% from "conky/map.jinja" import conky with context %}

include:
  - optsrc

conky_deps:
  pkg.installed:
    - names:
      - cmake
      - pkg-config
      - libx11-dev
      - libxext-dev
      - libxdamage-dev
      - libxft-dev
      - libxinerama-dev
      - libimlib2-dev
      - liblua5.3-dev
      - libncurses-dev
    - require:
      - file: optsrc

conky_git:
  git.latest:
    - name: {{ conky.repo }}
    - rev: v{{ conky.version }}
    - target: /opt/src/conky
    - require:
      - pkg: conky_deps

conky_build:
  cmd.run:
    - cwd: /opt/src/conky
    - name: |
        mkdir -p build
        cd build
        cmake -DCMAKE_INSTALL_PREFIX={{ conky.prefix }} ..
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - onchanges:
      - git: conky_git
