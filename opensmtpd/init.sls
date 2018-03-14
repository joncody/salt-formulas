{% from "opensmtpd/map.jinja" import opensmtpd with context %}

include:
  - asr

opensmtpd:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - libbison-dev
      - bison
      - libevent-dev
      - libtool
      - libssl-dev
      - openssl
      - libasr-dev
      - sqlite3
      - libsqlite3-dev
    - require:
      - cmd: asr
  git.latest:
    - name: {{ opensmtpd.repo }}
    - branch: portable
    - target: /opt/src/opensmtpd
    - require:
      - pkg: opensmtpd
  cmd.run:
    - cwd: /opt/src/opensmtpd
    - name: ./bootstrap && LDFLAGS=-L/opt/asr/lib CPPFLAGS=-I/opt/asr/include ./configure --prefix=/opt/opensmtpd --with-gnu-ld --with-table-db && make && make install && make clean
    - unless: test -d /opt/opensmtpd
    - require:
      - user: opensmtpd-daemon

opensmtpd-daemon:
  user.present:
    - name: _smtpd
    - gid: _smtpd
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - loginclass: "SMTP Daemon"
    - require:
      - group: opensmtpd-daemon
  group.present:
    - name: _smtpd
    - system: True
    - require:
      - user: opensmtpd-queue

opensmtpd-queue:
  user.present:
    - name: _smtpq 
    - gid: _smtpq
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - loginclass: "SMTPD Queue"
    - require:
      - group: opensmtpd-queue
  group.present:
    - name: _smtpq
    - system: True
    - require:
      - user: opensmtpd-filter

opensmtpd-filter:
  user.present:
    - name: _smtpf 
    - gid: _smtpf
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - loginclass: "SMTPD Filter"
    - require:
      - group: opensmtpd-filter
  group.present:
    - name: _smtpf
    - system: True
    - require:
      - git: opensmtpd

opensmtpd-extras:
  git.latest:
    - name: {{ opensmtpd.extras_repo }}
    - branch: master
    - target: /opt/src/opensmtpd-extras
    - require:
      - cmd: opensmtpd
  cmd.run:
    - cwd: /opt/src/opensmtpd-extras
    - name: ./bootstrap && LDFLAGS=-L/opt/postgresql/lib CPPFLAGS=-I/opt/postgresql/include ./configure --prefix=/opt/opensmtpd-extras --libexecdir=/opt/opensmtpd/libexec --with-gnu-ld --with-table-postgres --with-table-passwd --with-table-sqlite && make && make install && make clean
    - unless: test -d /opt/opensmtpd
    - require:
      - git: opensmtpd-extras
