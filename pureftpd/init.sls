{% from "pureftpd/map.jinja" import pureftpd with context %}

include:
  - optsrc
  - .conf

pureftpd_group:
  group.present:
    - name: pureftpd
    - system: True

pureftpd_user:
  user.present:
    - name: pureftpd
    - gid: pureftpd
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: pureftpd_group

ftp_group:
  group.present:
    - name: ftp
    - system: True

ftp_user:
  user.present:
    - name: ftp
    - gid: ftp
    - system: True
    - home: /ftp
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: ftp_group

pureftpd_deps:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - build-essential
      - git
      - libldap2-dev
      - libpam0g-dev
      - libssl-dev
    - require:
      - file: optsrc

pureftpd_git:
  git.latest:
    - name: {{ pureftpd.repo }}
    - rev: {{ pureftpd.version }}
    - target: /opt/src/pureftpd
    - require:
      - pkg: pureftpd_deps

pureftpd_build:
  cmd.run:
    - cwd: /opt/src/pureftpd
    - name: |
        ./autogen.sh
        ./configure --prefix={{ pureftpd.prefix }} --with-pam --with-puredb --with-ftpwho --with-ldap --with-tls
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - onchanges:
      - git: pureftpd_git
    - require:
      - user: pureftpd_user
      - user: ftp_user
