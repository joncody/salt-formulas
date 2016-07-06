{% from "git/map.jinja" import git with context %}

git:
  pkg.installed:
    - name: {{ git.package }}
