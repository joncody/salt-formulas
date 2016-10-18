{% from "grafana/map.jinja" import grafana with context %}

grafana:
  cmd.run:
    - name: go get github.com/grafana/grafana; echo ''

grafana-backend-setup:
  cmd.run:
    - cwd: {{ salt['environ.get']('GOPATH') }}/src/github.com/grafana/grafana
    - name: go run build.go setup
    - require:
      - cmd: grafana

grafana-backend-build:
  cmd.run:
    - cwd: {{ salt['environ.get']('GOPATH') }}/src/github.com/grafana/grafana
    - name: go run build.go build
    - require:
      - cmd: grafana-backend-setup

grafana-frontend-assets:
  cmd.run:
    - cwd: {{ salt['environ.get']('GOPATH') }}/src/github.com/grafana/grafana
    - name: npm install
    - require:
      - cmd: grafana-backend-build

grafana-frontend-build:
  cmd.run:
    - cwd: {{ salt['environ.get']('GOPATH') }}/src/github.com/grafana/grafana
    - name: npm run build
    - require:
      - cmd: grafana-frontend-assets
