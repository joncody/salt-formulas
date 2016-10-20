{% from "uwsgi/map.jinja" import uwsgi with context %}


opt-src-directory:
  file.directory:
    - name: /opt/src
    - user: root
    - group: root
    - mode: 755
    - makedirs: True


uwsgi-directory:
  file.directory:
    - name: /opt/uwsgi
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require:
      - file: opt-src-directory

uwsgi:
  file.managed:
    - name: /opt/src/uwsgi-lts.tar.gz
    - source: https://projects.unbit.it/downloads/uwsgi-lts.tar.gz
    - source_hash: sha256={{ uwsgi.checksum }}
    - require:
      - file: uwsgi-directory
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf uwsgi-lts.tar.gz -C /opt/uwsgi
    - require:
      - file: uwsgi


uwsgi-build:
  cmd.run:
    - cwd: /opt/uwsgi
    - name: make
    - require:
      - cmd: uwsgi
