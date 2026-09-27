{% from "postgresql/map.jinja" import postgresql with context %}

include:
  - optsrc

postgres_group:
  group.present:
    - name: postgres
    - system: True

postgres_user:
  user.present:
    - name: postgres
    - gid: postgres
    - system: True
    - home: /opt/postgresql/data
    - createhome: False
    - shell: /bin/bash
    - require:
      - group: postgres_group

postgresql_deps:
  pkg.installed:
    - names:
      - bison
      - build-essential
      - flex
      - git
      - libldap2-dev
      - libpam0g-dev
      - libperl-dev
      - libreadline-dev
      - libssl-dev
      - libxml2-dev
      - libxslt1-dev
      - pkg-config
      - python3-all-dev
    - require:
      - file: optsrc

postgresql_git:
  git.latest:
    - name: {{ postgresql.repo }}
    - branch: {{ postgresql.branch }}
    - rev: {{ postgresql.branch }}
    - target: /opt/src/postgresql
    - require:
      - pkg: postgresql_deps

postgresql_build:
  cmd.run:
    - cwd: /opt/src/postgresql
    - name: |
        ./configure --prefix={{ postgresql.prefix }} --enable-debug --with-perl --with-python --with-pam --with-ldap --with-openssl --with-libxml --with-libxslt --with-gnu-ld
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - onchanges:
      - git: postgresql_git
    - require:
      - user: postgres_user

postgresql-data-dir:
  file.directory:
    - name: /opt/postgresql/data
    - user: postgres
    - group: postgres
    - mode: 700
    - makedirs: True
    - require:
      - cmd: postgresql_build

postgresql-initdb:
  cmd.run:
    - name: /opt/postgresql/bin/initdb -D /opt/postgresql/data
    - user: postgres
    - group: postgres
    - creates: /opt/postgresql/data/PG_VERSION
    - require:
      - file: postgresql-data-dir
