{% from "riak/map.jinja" import riak with context %}

erlang:
  pkg.installed:
    - names:
      - build-essential
      - autoconf
      - libncurses5-dev
      - openssl
      - libssl-dev
      - fop
      - xsltproc
      - unixodbc-dev
      - git
      - libwxbase3.0-dev
      - libwxgtk3.0-dev
      - libqt4-opengl-dev
  file.managed:
    - name: /opt/src/otp_src_R16B02-basho8.tar.gz
    - source: http://s3.amazonaws.com/downloads.basho.com/erlang/otp_src_R16B02-basho8.tar.gz
    - source_hash: sha1=e9e860e2679f3f149ea62ba8ef3602facd3cafcd
    - require:
      - pkg: erlang
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf otp_src_R16B02-basho8.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: erlang

erlang-build:
  cmd.run:
    - cwd: /opt/src/OTP_R16B02_basho8
    - name: ./otp_build autoconf && ./configure && make install
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: erlang

riak:
  pkg.installed:
    - names:
      - libc6-dev-i386
  file.managed:
    - name: /opt/src/riak-{{ riak.version }}.tar.gz
    - source: http://s3.amazonaws.com/downloads.basho.com/riak/2.1/{{ riak.version }}/riak-{{ riak.version }}.tar.gz
    - source_hash: sha1={{ riak.checksum }}
    - require:
      - pkg: riak
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf riak-{{ riak.version }}.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: riak

riak-build:
  cmd.run:
    - cwd: /opt/src/riak-{{ riak.version }}
    - name: make rel
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: riak
