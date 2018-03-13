{% from "asr/map.jinja" import asr with context %}

include:
  - optsrc

asr:
  pkg.installed:
    - names:
      - build-essential
      - autotools-dev
      - automake
      - autoconf
      - pkg-config
      - libtool
    - require:
      - file: optsrc
  git.latest:
    - name: {{ asr.repo }}
    - branch: master
    - target: /opt/src/libasr
    - require:
      - pkg: asr
  cmd.run:
    - cwd: /opt/src/libasr
    - name: ./bootstrap && ./configure --prefix=/opt/asr --with-gnu-ld && make && make install && make clean
    - unless: test -d /opt/asr
    - require:
      - git: asr
