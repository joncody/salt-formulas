{% from "nginx/map.jinja" import nginx with context %}

nginx-conf:
  file.managed:
    - name: /opt/nginx/conf/nginx.conf
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - source: salt://nginx/files/nginx.conf
    - require:
      - cmd: nginx_build
