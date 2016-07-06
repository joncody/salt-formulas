{% from "conky/map.jinja" import conky with context %}

conky:
  pkg.installed:
    - name: {{ conky.package }}
