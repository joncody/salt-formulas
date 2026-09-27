{% from "nginx/map.jinja" import nginx with context %}

include:
  - optsrc
  - .conf

nginx_group:
  group.present:
    - name: {{ nginx.group }}
    - system: True

nginx_user:
  user.present:
    - name: {{ nginx.user }}
    - gid: {{ nginx.group }}
    - system: True
    - home: /var/empty
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: nginx_group

nginscript_git:
  git.latest:
    - name: {{ nginx.njs_repo }}
    - rev: {{ nginx.njs_rev }}
    - target: /opt/src/njs
    - require:
      - file: optsrc

nginx_deps:
  pkg.installed:
    - names:
      - build-essential
      - git
      - libaio-dev
      - libpcre2-dev
      - libssl-dev
      - zlib1g-dev
    - require:
      - file: optsrc

nginx_git:
  git.latest:
    - name: {{ nginx.repo }}
    - branch: {{ nginx.branch }}
    - rev: {{ nginx.branch }}
    - target: /opt/src/nginx
    - require:
      - pkg: nginx_deps

nginx_build:
  cmd.run:
    - cwd: /opt/src/nginx
    - name: |
        ./auto/configure \
          --prefix={{ nginx.prefix }} \
          --user={{ nginx.user }} \
          --group={{ nginx.group }} \
          --add-module=/opt/src/njs/nginx \
          --with-http_ssl_module \
          --with-http_v2_module \
          --with-threads \
          --with-pcre
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - onchanges:
      - git: nginx_git
      - git: nginscript_git
    - require:
      - user: nginx_user
