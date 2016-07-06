{% from "dovecot/map.jinja" import dovecot with context %}

dovecot:
  file.managed:
    - name: /opt/src/dovecot-{{ dovecot.version }}.tar.gz
    - source: http://www.dovecot.org/releases/2.2/dovecot-{{ dovecot.version }}.tar.gz
    - source_hash: sha1={{ dovecot.checksum }}
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf dovecot-{{ dovecot.version }}.tar.gz
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - user: dovecot
  user.present:
    - name: {{ dovecot.dovecot_user }} 
    - gid: {{ dovecot.dovecot_group }}
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: {{ dovecot.shell }}
    - require:
      - group: dovecot
  group.present:
    - name: {{ dovecot.dovecot_group }}
    - system: True
    - require:
      - user: dovenull

dovenull:
  user.present:
    - name: {{ dovecot.dovenull_user }} 
    - gid: {{ dovecot.dovenull_group }}
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: {{ dovecot.shell }}
    - require:
      - group: dovenull
  group.present:
    - name: {{ dovecot.dovenull_group }}
    - system: True

dovecot-build:
  cmd.run:
    - cwd: /opt/src/dovecot-{{ dovecot.version }}
    - name: ./configure --prefix=/opt/dovecot && make install clean
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: dovecot
