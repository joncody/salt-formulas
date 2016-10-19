{% from "uwsgi/map.jinja" import uwsgi with context %}

uwsgi:
  pkg.installed:
    - name: uwsgi
