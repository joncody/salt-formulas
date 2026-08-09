{% from "opensmtpd/map.jinja" import opensmtpd with context %}

include:
  - asr
  - postgresql

smtpd_group:
  group.present:
    - name: _smtpd
    - system: True

smtpd_user:
  user.present:
    - name: _smtpd
    - gid: _smtpd
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: smtpd_group

smtpq_group:
  group.present:
    - name: _smtpq
    - system: True

smtpq_user:
  user.present:
    - name: _smtpq
    - gid: _smtpq
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: smtpq_group

smtpf_group:
  group.present:
    - name: _smtpf
    - system: True

smtpf_user:
  user.present:
    - name: _smtpf
    - gid: _smtpf
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: smtpf_group

opensmtpd_deps:
  pkg.installed:
    - names:
      - libdb-dev
      - libsqlite3-dev
      - pkg-config
      - sqlite3
    - require:
      - cmd: asr_build
      - cmd: postgresql_build

opensmtpd_git:
  git.latest:
    - name: {{ opensmtpd.repo }}
    - branch: {{ opensmtpd.branch }}
    - rev: {{ opensmtpd.rev }}
    - target: /opt/src/opensmtpd
    - require:
      - pkg: opensmtpd_deps

opensmtpd_build:
  cmd.run:
    - cwd: /opt/src/opensmtpd
    - name: |
        ./bootstrap
        ./configure --prefix={{ opensmtpd.prefix }} --with-gnu-ld --with-table-db
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - env:
      - PKG_CONFIG_PATH: "/opt/asr/lib/pkgconfig:/opt/postgresql/lib/pkgconfig"
      - LDFLAGS: "-L/opt/asr/lib -L/opt/postgresql/lib"
      - CPPFLAGS: "-I/opt/asr/include -I/opt/postgresql/include"
    - onchanges:
      - git: opensmtpd_git
    - creates: {{ opensmtpd.prefix }}/sbin/smtpd
    - require:
      - user: smtpd_user
      - user: smtpq_user
      - user: smtpf_user
