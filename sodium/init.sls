{% from "sodium/map.jinja" import sodium with context %}

incldue:
  - optsrc

sodium:
  pkg.installed:
    - names:
      - libevent-dev
      - valgrind
    - require:
      - file: optsrc
  git.latest:
    - name: {{ sodium.repo }}
    - branch: master
    - target: /opt/src/libsodium
    - require:
      - pkg: sodium
  cmd.run:
    - cwd: /opt/src/libsodium
    - name: ./autogen.sh && ./configure --prefix=/opt/sodium --enable-debug --enable-opt --enable-valgrind --with-pthreads --with-gnu-ld && make && make install && make clean
    - require:
      - git: sodium
