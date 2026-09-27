{% from "sodium/map.jinja" import sodium with context %}

include:
  - optsrc

sodium_deps:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - build-essential
      - libtool
      - pkg-config
    - require:
      - file: optsrc

sodium_git:
  git.latest:
    - name: {{ sodium.repo }}
    - rev: {{ sodium.version }}
    - target: /opt/src/libsodium
    - require:
      - pkg: sodium_deps

sodium_build:
  cmd.run:
    - cwd: /opt/src/libsodium
    - name: |
        ./autogen.sh
        ./configure --prefix={{ sodium.prefix }} --enable-debug --enable-opt --with-pthreads --with-gnu-ld
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - onchanges:
      - git: sodium_git
