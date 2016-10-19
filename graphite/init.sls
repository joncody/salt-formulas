{% from "graphite/map.jinja" import graphite with context %}

install_pip:
  pkg.installed:
    - names:
      - python-pip
      - python-dev

graphite:
  cmd.run:
    - name: pip install whisper carbon graphite-web
    - require:
      - pkg: install_pip
