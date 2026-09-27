{% from "asr/map.jinja" import asr with context %}

include:
  - optsrc

asr_deps:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - build-essential
      - libevent-dev
      - libssl-dev
      - libtool
      - pkg-config
    - require:
      - file: optsrc

asr_git:
  git.latest:
    - name: {{ asr.repo }}
    - rev: {{ asr.version }}
    - target: /opt/src/libasr
    - force_reset: True
    - require:
      - pkg: asr_deps

asr_build:
  cmd.run:
    - cwd: /opt/src/libasr
    - name: |
        ./bootstrap
        ./configure --prefix={{ asr.prefix }} --with-gnu-ld
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - onchanges:
      - git: asr_git
