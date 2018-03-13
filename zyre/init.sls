{% from "zyre/map.jinja" import zyre with context %}

include:
  - optsrc

zyre:
  pkg.installed:
    - name:
      - git
      - build-essential
      - libtool
      - pkg-config
      - autotools-dev
      - autoconf
      - automake
      - cmake
      - uuid-dev
      - libpcre3-dev
      - valgrind
      - asciidoc
      - liblz4-dev
    - require:
      - file: optsrc
  git.latest:
    - name: {{ zyre.repo }}
    - branch: master
    - target: /opt/src/zyre
    - require:
      - pkg: zyre
  cmd.run:
    - cwd: /opt/src/zyre
    - name: ./autogen.sh && ./configure --prefix=/opt/zyre --with-gnu-ld --with-libzmq --with-libczmq --with-docs && make && make install && make clean
    - require:
      - git: zyre