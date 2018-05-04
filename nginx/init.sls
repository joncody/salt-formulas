{% from "nginx/map.jinja" import nginx with context %}

include:
  - optsrc

nginscript:
  git.latest:
    - name: {{ nginx.njs_repo }}
    - branch: {{ nginx.njs_branch }}
    - rev: {{ nginx.njs_rev }}
    - target: /opt/src/njs
    - require:
      - file: optsrc

nginx:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - autotools-dev
      - build-essential
      - cmake
      - git
      - libaio-dev
      - libatomic-ops-dev
      - libevent-dev
      - libgd-dev
      - libgeoip-dev
      - libpcre3-dev
      - libperl-dev
      - libssl-dev
      - libtool
      - libxslt1-dev
      - libxml2-dev
      - openssl
      - pkg-config
      - valgrind
      - zlib1g-dev
    - require:
      - git: nginscript
  git.latest:
    - name: {{ nginx.repo }}
    - branch: {{ nginx.branch }}
    - rev: {{ nginx.rev }}
    - target: /opt/src/nginx
    - require:
      - pkg: nginx
  cmd.run:
    - cwd: /opt/src/nginx
    - name: ./auto/configure --prefix=/opt/nginx --add-module=/opt/src/njs/nginx --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_geoip_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-threads --with-pcre --with-debug --with-mail --with-mail_ssl_module --with-file-aio --with-libatomic --with-compat --with-stream --with-stream_ssl_module --with-stream_realip_module --with-stream_geoip_module --with-stream_ssl_preread_module --with-http_perl_module --with-select_module && make && make install && make clean
    - unless: test -d /opt/nginx
    - require:
      - user: nginx
  user.present:
    - name: {{ nginx.user }} 
    - gid: {{ nginx.group }}
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: nginx
  group.present:
    - name: {{ nginx.group }}
    - system: True
    - require:
      - git: nginx
