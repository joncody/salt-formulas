{% from "uwsgi/map.jinja" import uwsgi with context %}

install_pip:
  pkg.installed:
    - names:
      - python-pip
      - python-dev

uwsgi:
  cmd.run:
    - name: pip install uwsgi
    - require:
      - pkg: install_pip
