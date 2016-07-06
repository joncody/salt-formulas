{% from "nginx/map.jinja" import nginx with context %}

include:
  - nginx

nginx-conf:
  file.managed:
    - name: {{ nginx.conf }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://nginx/files/nginx.conf
    - require:
      - cmd: nginx-build
