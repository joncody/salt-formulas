{% from "sodium/map.jinja" import sodium with context %}

include:
  - optsrc

sodium:
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
    - name: {{ sodium.repo }}
    - branch: {{ sodium.branch }}
    - rev: {{ sodium.rev }}
    - target: /opt/src/libsodium
    - require:
      - pkg: sodium
  cmd.run:
    - cwd: /opt/src/libsodium
    - name: ./autogen.sh && ./configure --prefix=/opt/sodium --enable-debug --enable-opt --enable-valgrind --with-pthreads --with-gnu-ld && make && make install && make clean
    - unless: test -d /opt/sodium
    - require:
      - git: sodium
