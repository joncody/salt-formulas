{% from "turnserver/map.jinja" import turnserver with context %}

turnserver:
  pkg.installed:
    - names:
      - libevent-dev
  file.managed:
    - name: /opt/src/turnserver-{{ turnserver.version }}.tar.gz
    - source: http://turnserver.open-sys.org/downloads/v{{ turnserver.version }}/turnserver-{{ turnserver.version }}.tar.gz
    - source_hash: sha1={{ turnserver.checksum }}
    - require:
      - pkg: turnserver
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf turnserver-{{ turnserver.version }}.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: turnserver

turnserver-build:
  cmd.run:
    - cwd: /opt/src/turnserver-{{ turnserver.version }}
    - name: ./configure --prefix=/opt/turnserver && make check install clean
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: turnserver
