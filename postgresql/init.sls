{% from "postgresql/map.jinja" import postgresql with context %}

postgresql:
  pkg.installed:
    - names:
      - python-dev
      - libssl-dev
      - libxslt1-dev
      - libxml2-dev
      - libreadline-dev
      - bison
      - flex
  file.managed:
    - name: /opt/src/postgresql-{{ postgresql.version }}.tar.gz
    - source: https://ftp.postgresql.org/pub/source/v{{ postgresql.version }}/postgresql-{{ postgresql.version }}.tar.gz
    - source_hash: sha256={{ postgresql.checksum }}
    - require:
      - pkg: postgresql
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf postgresql-{{ postgresql.version }}.tar.gz
    - require:
      - user: postgresql
  user.present:
    - name: {{ postgresql.user }}
    - gid: {{ postgresql.group }}
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: {{ postgresql.shell }}
    - require:
      - group: {{ postgresql.group }}
  group.present:
    - name: {{ postgresql.group }}
    - system: True
    - require:
      - file: postgresql

postgresql-build:
  cmd.run:
    - cwd: /opt/src/postgresql-{{ postgresql.version }}
    - name: ./configure --prefix=/opt/postgresql --with-openssl --with-libxml --with-libxslt --with-python && make install clean
    - require:
      - cmd: postgresql

postgresql-data:
  cmd.run:
    - cwd: /opt/postgresql
    - name: mkdir /opt/postgresql/data && chown postgres /opt/postgresql/data
    - require:
      - cmd: postgresql-build

postgresql-init:
  cmd.run:
    - cwd: /opt/postgresql/data
    - name: /opt/postgresql/bin/initdb -D /opt/postgresql/data && /opt/postgresql/bin/pg_ctl start -D /opt/postgresql/data -l logfile
    - user: postgres
    - group: postgres
    - shell: /bin/bash
    - require:
      - cmd: postgresql-data
