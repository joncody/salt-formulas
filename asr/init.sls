{% from "asr/map.jinja" import asr with context %}

include:
  - optsrc

asr:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - autotools-dev
      - build-essential
      - cmake
      - git
      - libevent-dev
      - libssl-dev
      - libtool
      - openssl
      - pkg-config
      - valgrind
    - require:
      - file: optsrc
  git.latest:
    - name: {{ asr.repo }}
    - branch: {{ asr.branch }}
    - rev: {{ asr.rev }}
    - target: /opt/src/libasr
    - require:
      - pkg: asr
  cmd.run:
    - cwd: /opt/src/libasr
    - name: ./bootstrap && ./configure --prefix=/opt/asr --with-gnu-ld && make && make install && make clean
    - unless: test -d /opt/asr
    - require:
      - git: asr
