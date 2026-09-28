{% from "dovecot/map.jinja" import dovecot with context %}

include:
  - sodium
  - postgresql
  - .conf

dovecot_group:
  group.present:
    - name: dovecot
    - system: True

dovecot_user:
  user.present:
    - name: dovecot
    - gid: dovecot
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: dovecot_group

dovenull_group:
  group.present:
    - name: dovenull
    - system: True

dovenull_user:
  user.present:
    - name: dovenull
    - gid: dovenull
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: dovenull_group

vmail_group:
  group.present:
    - name: vmail
    - system: True

vmail_user:
  user.present:
    - name: vmail
    - gid: vmail
    - system: True
    - home: /var/vmail
    - createhome: True
    - shell: /usr/sbin/nologin
    - require:
      - group: vmail_group

vmail_dir:
  file.directory:
    - name: /var/vmail
    - user: vmail
    - group: vmail
    - mode: '0770'
    - makedirs: True
    - require:
      - user: vmail_user

dovecot_deps:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - build-essential
      - gettext
      - libarchive-dev
      - libbz2-dev
      - libcap-dev
      - liblz4-dev
      - liblzma-dev
      - libsqlite3-dev
      - libtool
      - libwrap0-dev
      - pkg-config
      - zlib1g-dev
    - require:
      - cmd: sodium_build
      - cmd: postgresql_build

dovecot_git:
  git.latest:
    - name: {{ dovecot.repo }}
    - branch: {{ dovecot.branch }}
    - rev: {{ dovecot.branch }}
    - target: /opt/src/dovecot
    - force_reset: True
    - require:
      - pkg: dovecot_deps

dovecot_build:
  cmd.run:
    - cwd: /opt/src/dovecot
    - name: |
        set -e
        NOCONFIGURE=1 ./autogen.sh
        PANDOC=false ./configure --prefix={{ dovecot.prefix }} \
          --with-shadow \
          --with-pam \
          --with-sql=yes \
          --with-pgsql \
          --with-sqlite \
          --with-sodium \
          --with-zlib \
          --with-bzlib \
          --with-lzma \
          --with-lz4 \
          --with-ssl=openssl \
          --with-gnu-ld
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - env:
      - PANDOC: "false"
      - PKG_CONFIG_PATH: "/opt/sodium/lib/pkgconfig:/opt/postgresql/lib/pkgconfig"
      - LDFLAGS: "-L/opt/sodium/lib -L/opt/postgresql/lib"
      - CPPFLAGS: "-I/opt/sodium/include -I/opt/postgresql/include"
      - LD_LIBRARY_PATH: "/opt/sodium/lib:/opt/postgresql/lib"
    - onchanges:
      - git: dovecot_git
    - require:
      - user: dovecot_user
      - user: dovenull_user
      - user: vmail_user
