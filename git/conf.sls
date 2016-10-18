{% from "git/map.jinja" import git with context %}

include:
  - git

git-conf:
  cmd.run:
    - cwd: {{ salt['user.info'](git.user).home }}
    - name: git config --global user.name {{ git.gituser }} && git config --global user.email {{ git.gitemail }}
    - runas: {{ git.user }}
    - require:
      - pkg: git
