{% from "dovecot/map.jinja" import dovecot with context %}

include:
  - sodium
  - postgresql

exclude:
  - id: postgresql-data
  - id: postgresql-init

dovecot:
  pkg.installed:
    - names:
      - gettext
      - libarchive-dev
      - libbz2-dev
      - libcap-dev
      - liblz4-dev
      - liblzma-dev
      - libsqlite3-dev
      - libwrap0-dev
      - pandoc
      - sqlite3
      - zlib1g-dev
    - require:
      - cmd: sodium
      - cmd: postgresql
  git.latest:
    - name: {{ dovecot.repo }}
    - branch: {{ dovecot.branch }}
    - rev: {{ dovecot.rev }}
    - target: /opt/src/dovecot
    - require:
      - pkg: dovecot
  cmd.run:
    - cwd: /opt/src/dovecot
    - name: ./autogen.sh && LDFLAGS='-L/opt/sodium/lib -L/opt/postgresql/lib' CPPFLAGS='-I/opt/sodium/include -I/opt/postgresql/include' ./configure --prefix=/opt/dovecot --with-shadow --with-pam --with-ldap=yes --with-sql=yes --with-pgsql --with-sqlite --with-sodium --with-zlib --with-bzlib --with-lzma --with-lz4 --with-libcap --with-libwrap --with-ssl=openssl --with-docs --with-gnu-ld && make && make install && make clean
    - unless: test -d /opt/dovecot
    - require:
      - user: dovecot
  user.present:
    - name: dovecot
    - gid: dovecot
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: dovecot
  group.present:
    - name: dovecot
    - system: True
    - require:
      - user: dovenull

dovenull:
  user.present:
    - name: dovenull
    - gid: dovenull
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: dovenull
  group.present:
    - name: dovenull
    - system: True
    - require:
      - git: dovecot
