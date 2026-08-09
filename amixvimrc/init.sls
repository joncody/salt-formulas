{% from "amixvimrc/map.jinja" import amixvimrc with context %}

include:
  - optsrc

amixvimrc_pkg:
  pkg.installed:
    - name: vim
    - require:
      - file: optsrc

amixvimrc_git:
  git.latest:
    - name: {{ amixvimrc.repo }}
    - branch: {{ amixvimrc.branch }}
    - rev: {{ amixvimrc.rev }}
    - target: /opt/vim_runtime
    - depth: 1
    - require:
      - pkg: amixvimrc_pkg

amixvimrc_install:
  cmd.run:
    - cwd: /opt/vim_runtime
    - name: ./install_awesome_parameterized.sh /opt/vim_runtime --all && printf "\nset nowrap\nset nu\nset t_Co=256" >> /opt/vim_runtime/my_configs.vim
    - onchanges:
      - git: amixvimrc_git
    - creates: /opt/vim_runtime/vimrcs/basic.vim
