{% from "graphite/map.jinja" import graphite with context %}

install_pip:
  pkg.installed:
    - names:
      - python-pip
      - python-dev

graphite:
  pkg.installed:
    - names:
      - python-cairo
      - python-django
      - python-django-tagging
      - python-twisted
      - python-memcache
      - python-pysqlite2
      - python-simplejson
    - require:
      - pkg: install_pip
  cmd.run:
    - name: pip install whisper carbon graphite-web
    - require:
      - pkg: graphite

graphite-db:
  cmd.run:
    - name: PYTHONPATH=/opt/graphite/webapp django-admin.py migrate --settings=graphite.settings --run-syncdb
    - require:
      - cmd: graphite
