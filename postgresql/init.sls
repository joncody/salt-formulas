{% from "postgresql/map.jinja" import postgresql with context %}

include:
  - optsrc

postgresql:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - autotools-dev
      - bison
      - build-essential
      - cmake
      - flex
      - git
      - libbison-dev
      - libevent-dev
      - libfl-dev
      - libldap2-dev
      - libpam0g-dev
      - libperl-dev
      - libreadline-dev
      - libssl-dev
      - libtool
      - libxslt1-dev
      - libxml2-dev
      - openssl
      - pkg-config
      - python3-all-dev
      - valgrind
    - require:
      - file: optsrc
  git.latest:
    - name: {{ postgresql.repo }}
    - branch: {{ postgresql.branch }}
    - rev: {{ postgresql.rev }}
    - target: /opt/src/postgresql
    - require:
      - pkg: postgresql
  cmd.run:
    - cwd: /opt/src/postgresql
    - name: ./configure --prefix=/opt/postgresql --enable-debug --with-perl --with-python --with-pam --with-ldap --with-openssl --with-libxml --with-libxslt --with-gnu-ld && make && make install && make clean
    - unless: test -d /opt/postgresql
    - require:
      - user: postgresql
  user.present:
    - name: postgres
    - gid: postgres
    - system: True
    - home: /opt/postgresql/data
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: postgresql
  group.present:
    - name: postgres
    - system: True
    - require:
      - git: postgresql

postgresql-data:
  cmd.run:
    - cwd: /opt/postgresql
    - name: mkdir -p /opt/postgresql/data && chown postgres /opt/postgresql/data
    - require:
      - cmd: postgresql

postgresql-init:
  cmd.run:
    - cwd: /opt/postgresql/data
    - name: /opt/postgresql/bin/initdb -D /opt/postgresql/data && /opt/postgresql/bin/pg_ctl start -D /opt/postgresql/data -l logfile
    - user: postgres
    - group: postgres
    - shell: /bin/bash
    - unless: test -d /opt/postgresql/data
    - require:
      - cmd: postgresql-data
