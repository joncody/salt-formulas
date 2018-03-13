{% from "filemq/map.jinja" import filemq with context %}

include:
  - optsrc

filemq:
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
    - name: {{ filemq.repo }}
    - branch: master
    - target: /opt/src/filemq
    - require:
      - pkg: filemq
  cmd.run:
    - cwd: /opt/src/filemq
    - name: ./autogen.sh && ./configure --prefix=/opt/filemq --with-gnu-ld --with-libsodium --with-libzmq --with-libczmq --with-docs && make && make install && make clean
    - require:
      - git: filemq