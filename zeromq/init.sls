{% from "zeromq/map.jinja" import zeromq with context %}

zeromq:
  pkg.installed:
    - name: automake

libsodium:
  git.latest:
    - name: git://github.com/jedisct1/libsodium.git
    - rev: master
    - target: /opt/src/libsodium
    - user: root
    - require:
      - pkg: zeromq
  cmd.run:
    - cwd: /opt/src/libsodium
    - name: ./autogen.sh && ./configure --prefix=/usr && make install clean && ldconfig
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - git: libsodium

libzmq:
  git.latest:
    - name: git://github.com/zeromq/libzmq.git
    - rev: master
    - target: /opt/src/libzmq
    - user: root
    - require:
      - cmd: libsodium
  cmd.run:
    - cwd: /opt/src/libzmq
    - name: ./autogen.sh && ./configure --prefix=/usr && make install clean && ldconfig
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - git: libzmq

czmq:
  git.latest:
    - name: git://github.com/zeromq/czmq.git
    - rev: master
    - target: /opt/src/czmq
    - user: root
    - require:
      - cmd: libzmq
  cmd.run:
    - cwd: /opt/src/czmq
    - name: ./autogen.sh && ./configure --prefix=/usr && make install clean && ldconfig
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - git: czmq

zyre:
  git.latest:
    - name: git://github.com/zeromq/zyre.git
    - rev: master
    - target: /opt/src/zyre
    - user: root
    - require:
      - cmd: czmq
  cmd.run:
    - cwd: /opt/src/zyre
    - name: ./autogen.sh && ./configure --prefix=/usr && make install clean && ldconfig
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - git: zyre
