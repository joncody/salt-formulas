{% from "node/map.jinja" import node with context %}

include:
  - optsrc

node_deps:
  pkg.installed:
    - names:
      - build-essential
      - git
      - libssl-dev
      - pkg-config
      - python3-all-dev
      - zlib1g-dev
    - require:
      - file: optsrc

node_git:
  git.latest:
    - name: {{ node.repo }}
    - branch: {{ node.branch }}
    - rev: {{ node.rev }}
    - target: /opt/src/node
    - require:
      - pkg: node_deps

node_build:
  cmd.run:
    - cwd: /opt/src/node
    - name: |
        ./configure --prefix={{ node.prefix }}
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - onchanges:
      - git: node_git
    - creates: {{ node.prefix }}/bin/node
