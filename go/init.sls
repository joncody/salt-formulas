{% from "go/map.jinja" import go with context %}

include:
  - optsrc

go_deps:
  pkg.installed:
    - names:
      - build-essential
      - git
    - require:
      - file: optsrc

# 1. Download an older Go compiler binary strictly for bootstrapping
go_bootstrap_archive:
  archive.extracted:
    - name: /opt/src/go_bootstrap_bin
    - source: https://go.dev/dl/go{{ go.bootstrap_version }}.linux-amd64.tar.gz
    - source_hash: {{ go.bootstrap_hash }}
    - archive_format: tar
    - enforce_ownership_on: /opt/src/go_bootstrap_bin

# 2. Clone Go 1.26.5 source code
go_git:
  git.latest:
    - name: {{ go.repo }}
    - branch: {{ go.branch }}
    - rev: {{ go.rev }}
    - target: /opt/src/go
    - require:
      - pkg: go_deps

# 3. Build Go 1.26.5 binaries from source code
go_build:
  cmd.run:
    - cwd: /opt/src/go/src
    - name: ./make.bash
    - env:
      - GOROOT_BOOTSTRAP: /opt/src/go_bootstrap_bin/go
      - GOPATH: /opt/src/go_work
    - onchanges:
      - git: go_git
    - creates: /opt/src/go/bin/go
