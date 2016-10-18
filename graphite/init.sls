{% from "graphite/map.jinja" import graphite with context %}

pip:
  pkg.installed:
    - names:
      - python-pip
      - python-dev

graphite:
  pip.installed:
    - pkgs:
       - whisper
       - carbon
       - graphite-web
    - require:
      - pkg: pip
