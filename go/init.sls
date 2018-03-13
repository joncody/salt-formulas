{% from "go/map.jinja" import go with context %}

include:
  - optsrc

go_bootstrap:
  git.latest:
    - name: {{ go.repo }}
    - branch: release-branch.go1.4
    - target: /opt/src/go_bootstrap
    - require:
      - file: optsrc
  cmd.run:
    - cwd: /opt/src/go_bootstrap
    - name: ./make.bash
    - require:
      - git: go_bootstrap

go:
  git.latest
    - name: {{ go.repo }}
    - branch: master
    - target: /opt/src/go
    - require:
      - cmd: go_bootstrap
  cmd.run:
    - cwd: /opt/src/go
    - name: GOROOT_BOOTSTRAP=/opt/src/go_bootstrap ./all.bash
    - require:
      - git: go
