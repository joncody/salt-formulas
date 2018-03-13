{% from "amixvimrc/map.jinja" import amixvimrc with context %}

include:
  - optsrc

amixvimrc:
  pkg.installed:
    - name: vim
    - require:
      - file: optsrc
  git.latest:
    - name: {{ amixvimrc.repo }}
    - branch: master
    - target: /opt/vim_runtime
    - depth: 1
    - require:
      - pkg: amixvimrc
  cmd.run:
    - cwd: /opt/vim_runtime
    - name: ./install_awesome_parameterized.sh /opt/vim_runtime --all
    - require:
      - git: amixvimrc

amixvimrc-custom:
  cmd.run:
    - cwd: /opt/vim_runtime
    - name: printf "\nset nowrap\nset nu\nset t_Co=256" >> /opt/vim_runtime/vimrcs/basic.vim
    - require:
      - cmd: amixvimrc
