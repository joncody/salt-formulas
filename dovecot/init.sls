{% from "dovecot/map.jinja" import dovecot with context %}

include:
  - optsrc

dovecot:
  pkg.installed:
    - names:
      - libldap2-dev
      - libpam0g-dev
      - zlib1g-dev
      - liblzma-dev
      - liblz4-dev
      - libarchive-dev
      - libcap-dev
      - libwrap0-dev
      - libssl-dev
      - openssl
      - libsodium-dev
    - require:
      - file: optsrc
  git.latest:
    - name: {{ dovecot.repo }}
    - branch: master
    - target: /opt/src/dovecot
    - require:
      - pkg: dovecot
  cmd.run:
    - cwd: /opt/src/dovecot
    - name: ./autogen.sh && ./configure --prefix=/opt/dovecot --with-shadow --with-pam --with-ldap=yes --with-sql=yes --with-pgsql --with-sqlite --with-sodium --with-zlib --with-bzlib --with-lzma --with-lz4 --with-libcap --with-libwrap --with-ssl=openssl --with-docs --with-gnu-ld && make && make install && make clean
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
