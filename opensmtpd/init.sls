{% from "opensmtpd/map.jinja" import opensmtpd with context %}

include:
  - asr
  - postgresql

exclude:
  - id: postgresql-data
  - id: postgresql-init

opensmtpd:
  pkg.installed:
    - names:
      - libdb-dev
      - libsqlite3-dev
      - sqlite3
    - require:
      - cmd: asr
      - cmd: postgresql
  git.latest:
    - name: {{ opensmtpd.repo }}
    - branch: {{ opensmtpd.branch }}
    - rev: {{ opensmtpd.rev }}
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
    - branch: {{ opensmtpd.extras_branch }}
    - rev: {{ opensmtpd.extras_rev }}
    - target: /opt/src/opensmtpd-extras
    - require:
      - cmd: opensmtpd
  cmd.run:
    - cwd: /opt/src/opensmtpd-extras
    - name: ./bootstrap && LDFLAGS=-L/opt/postgresql/lib CPPFLAGS=-I/opt/postgresql/include ./configure --prefix=/opt/opensmtpd-extras --libexecdir=/opt/opensmtpd/libexec --with-gnu-ld --with-table-postgres --with-table-passwd --with-table-sqlite && make && make install && make clean
    - unless: test -d /opt/opensmtpd
    - require:
      - git: opensmtpd-extras
