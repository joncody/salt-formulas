{% from "conky/map.jinja" import conky with context %}

include:
  - optsrc
  - .conf

conky_deps:
  pkg.installed:
    - names:
      - cmake
      - gperf
      - pkg-config
      - libx11-dev
      - libxext-dev
      - libxi-dev
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
    - force_reset: True
    - require:
      - pkg: conky_deps

conky_build:
  cmd.run:
    - cwd: /opt/src/conky
    - name: |
        rm -rf build
        cmake -B build -DCMAKE_INSTALL_PREFIX={{ conky.prefix }}
        cmake --build build -j{{ grains['num_cpus'] }}
        cmake --install build
        rm -rf build
        mkdir -p {{ conky.prefix }}
        git -C /opt/src/conky rev-parse HEAD > {{ conky.prefix }}/.git_commit
    - unless: |
        [ -x {{ conky.prefix }}/bin/conky ] && \
        [ -f {{ conky.prefix }}/.git_commit ] && \
        [ "$(git -C /opt/src/conky rev-parse HEAD)" = "$(cat {{ conky.prefix }}/.git_commit)" ]
    - require:
      - git: conky_git
