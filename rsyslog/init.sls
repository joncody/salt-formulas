{% from "rsyslog/map.jinja" import rsyslog with context %}


libfastjson:
  git.latest:
    - name: git://github.com/rsyslog/libfastjson
    - rev: master
    - target: /opt/src/libfastjson
    - user: root
  cmd.run:
    - cwd: /opt/src/libfastjson
    - name: ./autogen.sh && ./configure && make install
    - require:
      - git: libfastjson


rsyslog:
  pkg.installed:
    - names:
      - libestr-dev
      - libjson-c-dev
      - uuid-dev
      - libgcrypt11-dev
      - pkg-config
  file.managed:
    - name: /opt/src/rsyslog-{{ rsyslog.version }}.tar.gz
    - source: http://www.rsyslog.com/files/download/rsyslog/rsyslog-{{ rsyslog.version }}.tar.gz
    - source_hash: sha256={{ rsyslog.checksum }}
    - require:
      - pkg: rsyslog
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf rsyslog-{{ rsyslog.version }}.tar.gz
    - require:
      - file: rsyslog

rsyslog-configure:
  file.directory:
    - name: /var/spool/rsyslog
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require:
      - cmd: rsyslog
  cmd.run:
    - cwd: /opt/src/rsyslog-{{ rsyslog.version }}
    - name: ./configure --disable-liblogging-stdlog --disable-generate-man-pages
    - require:
      - file: rsyslog-configure

rsyslog-install:
  cmd.run:
    - cwd: /opt/src/rsyslog-{{ rsyslog.version }}
    - name: make install
    - require:
      - cmd: rsyslog-configure
