{% from "nginx/map.jinja" import nginx with context %}

nginx:
  pkg.installed:
    - names:
      - libssl-dev
      - libpcre3-dev
      - libxslt1-dev
      - libxml2-dev
      - libgeoip-dev
  file.managed:
    - name: /opt/src/nginx-{{ nginx.version }}.tar.gz
    - source: http://nginx.org/download/nginx-{{ nginx.version }}.tar.gz
    - source_hash: sha1={{ nginx.checksum }}
    - require:
      - pkg: nginx
  cmd.run:
    - cwd: /opt/src
    - name: tar xvzf nginx-{{ nginx.version }}.tar.gz
    - require:
      - user: nginx
  user.present:
    - name: {{ nginx.user }} 
    - gid: {{ nginx.group }}
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: {{ nginx.shell }}
    - require:
      - group: {{ nginx.group }}
  group.present:
    - name: {{ nginx.group }}
    - system: True
    - require:
      - file: nginx

nginx-build:
  cmd.run:
    - cwd: /opt/src/nginx-{{ nginx.version }}
    - name: ./configure --prefix=/opt/nginx --with-http_ssl_module --with-http_gzip_static_module --with-http_gunzip_module --with-http_auth_request_module --with-http_stub_status_module --with-http_realip_module --with-http_xslt_module --with-http_geoip_module --with-http_secure_link_module --with-http_random_index_module --with-http_sub_module --with-pcre && make install clean
    - require:
      - cmd: nginx
