{% from "opensmtpd/map.jinja" import opensmtpd with context %}

libasr:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - bison
      - libevent-dev
      - libtool
      - openssl
      - libdb-dev
  git.latest:
    - name: git://github.com/OpenSMTPD/libasr.git
    - rev: master
    - target: /opt/src/libasr
    - user: root
    - require:
      - pkg: libasr
  cmd.run:
    - cwd: /opt/src/libasr
    - name: ./bootstrap && ./configure --prefix=/usr && make install clean
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - git: libasr

opensmtpd:
  file.managed:
    - name: /opt/src/opensmtpd-{{ opensmtpd.version }}.tar.gz
    - source: http://www.opensmtpd.org/archives/opensmtpd-{{ opensmtpd.version }}.tar.gz
    - source_hash: sha256={{ opensmtpd.checksum }}
    - require:
      - cmd: libasr
  cmd.run:
    - cwd: /opt/src
    - name: mkdir -p /opt/src/opensmtpd && tar xvzf opensmtpd-{{ opensmtpd.version }}.tar.gz -C /opt/src/opensmtpd --strip-components=1
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - user: opensmtpd-daemon

opensmtpd-build:
  cmd.run:
    - cwd: /opt/src/opensmtpd
    - name: ./configure --prefix=/opt/opensmtpd --with-mailwrapper && make install clean
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: opensmtpd

opensmtpd-daemon:
  user.present:
    - name: {{ opensmtpd.daemon_user }} 
    - gid: {{ opensmtpd.daemon_group }}
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: {{ opensmtpd.shell }}
    - loginclass: "SMTP Daemon"
    - require:
      - group: opensmtpd-daemon
  group.present:
    - name: {{ opensmtpd.daemon_group }}
    - system: True
    - require:
      - user: opensmtpd-queue

opensmtpd-queue:
  user.present:
    - name: {{ opensmtpd.queue_user }} 
    - gid: {{ opensmtpd.queue_group }}
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: {{ opensmtpd.shell }}
    - loginclass: "SMTPD Queue"
    - require:
      - group: opensmtpd-queue
  group.present:
    - name: {{ opensmtpd.queue_group }}
    - system: True
    - require:
      - user: opensmtpd-filter

opensmtpd-filter:
  user.present:
    - name: {{ opensmtpd.filter_user }} 
    - gid: {{ opensmtpd.filter_group }}
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: {{ opensmtpd.shell }}
    - loginclass: "SMTPD Filter"
    - require:
      - group: opensmtpd-filter
  group.present:
    - name: {{ opensmtpd.filter_group }}
    - system: True
