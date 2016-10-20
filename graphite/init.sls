{% from "graphite/map.jinja" import graphite with context %}

install-deps:
  file.directory:
    - name: /opt/src
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
  pkg.installed:
    - names:
      - python-pip
      - python-dev
      - libcairo2-dev
      - libffi-dev
      - python-cairocffi
    - require:
      - file: install-deps
  cmd.run:
    - cwd: /opt/src
    - name: pip install django==1.9.10 django-tagging==0.4.3
    - require:
      - pkg: install-deps


graphite-web:
  git.latest:
    - name: git://github.com/graphite-project/graphite-web.git
    - rev: master
    - target: /opt/src/graphite-web
    - user: root
    - require:
      - pkg: install-deps
  cmd.run:
    - cwd: /opt/src/graphite-web
    - name: python setup.py install
    - require:
      - git: graphite-web

carbon:
  git.latest:
    - name: git://github.com/graphite-project/carbon.git
    - rev: master
    - target: /opt/src/carbon
    - user: root
    - require:
      - git: graphite-web
  cmd.run:
    - cwd: /opt/src/carbon
    - name: python setup.py install
    - require:
      - git: carbon

whisper:
  git.latest:
    - name: git://github.com/graphite-project/whisper.git
    - rev: master
    - target: /opt/src/whisper
    - user: root
    - require:
      - cmd: carbon
  cmd.run:
    - cwd: /opt/src/whisper
    - name: python setup.py install
    - require:
      - git: whisper

ceres:
  git.latest:
    - name: git://github.com/graphite-project/ceres.git
    - rev: master
    - target: /opt/src/ceres
    - user: root
    - require:
      - cmd: whisper
  cmd.run:
    - cwd: /opt/src/ceres
    - name: python setup.py install
    - require:
      - git: ceres

init-db:
  cmd.run:
    - cwd: /opt/graphite
    - name: PYTHONPATH=/opt/graphite/webapp django-admin.py migrate --settings=graphite.settings --run-syncdb
    - require:
      - cmd: graphite-web

db-ownership:
  cmd.run:
    - cwd: /opt/graphite
    - name: chown nobody:nogroup /opt/graphite/storage/graphite.db
    - require:
      - cmd: init-db

static-file:
  cmd.run:
    - cwd: /opt/graphite
    - name: PYTHONPATH=/opt/graphite/webapp django-admin.py collectstatic --noinput --settings=graphite.settings
    - require:
      - cmd: graphite-web
