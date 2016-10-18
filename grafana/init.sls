{% from "grafana/map.jinja" import grafana with context %}

grafana:
  cmd.run:
    - name: go get github.com/grafana/grafana
    - user: root
    - group: root
    - shell: /bin/bash

grafana-backend-setup:
  cmd.run:
    - cwd: $GOPATH/src/github.com/grafana/grafana
    - name: go run build.go setup
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: grafana

grafana-backend-build:
  cmd.run:
    - cwd: $GOPATH/src/github.com/grafana/grafana
    - name: go run build.go build
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: grafana-backend-setup

grafana-frontend-assets:
  cmd.run:
    - cwd: $GOPATH/src/github.com/grafana/grafana
    - name: npm install
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: grafana-backend-build

grafana-frontend-build:
  cmd.run:
    - cwd: $GOPATH/src/github.com/grafana/grafana
    - name: npm run build
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - cmd: grafana-frontend-assets
