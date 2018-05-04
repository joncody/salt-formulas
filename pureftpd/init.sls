{% from "pureftpd/map.jinja" import pureftpd with context %}

pureftpd:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - autotools-dev
      - build-essential
      - cmake
      - git
      - libevent-dev
      - libssl-dev
      - libtool
      - openssl
      - pkg-config
      - valgrind
      - libpam0g-dev
      - libldap2-dev
  git.latest:
    - name: {{ pureftpd.repo }}
    - branch: {{ pureftpd.branch }}
    - rev: {{ pureftpd.rev }}
    - target: /opt/src/pureftpd
    - require:
      - pkg: pureftpd
  cmd.run:
    - cwd: /opt/src/pureftpd
    - name: ./autogen.sh && ./configure --prefix=/opt/pureftpd --with-pam --with-puredb --with-ftpwho --with-ldap --with-debug --with-tls && make && make install && make clean
    - unless: test -d /opt/pureftpd
    - require:
      - user: pureftpd
  user.present:
    - name: pureftpd
    - gid: pureftpd
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: pureftpd
  group.present:
    - name: pureftpd
    - system: True
    - require:
      - user: ftp

ftp:
  user.present:
    - name: ftp
    - gid: ftp
    - system: True
    - home: /ftp
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: ftp
  group.present:
    - name: ftp
    - system: True
    - require:
      - git: pureftpd
