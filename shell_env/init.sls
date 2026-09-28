# 1. POSIX login environment
opt_profile_env:
  file.managed:
    - name: /etc/profile.d/opt_env.sh
    - source: salt://shell_env/files/opt_env.sh
    - user: root
    - group: root
    - mode: '0644'

# 2. System-wide shared library registration (replaces LD_LIBRARY_PATH)
opt_ld_conf:
  file.managed:
    - name: /etc/ld.so.conf.d/opt.conf
    - contents: |
        /opt/sodium/lib
        /opt/zmq/lib
        /opt/czmq/lib
        /opt/zyre/lib
        /opt/filemq/lib
        /opt/asr/lib
        /opt/postgresql/lib
    - user: root
    - group: root
    - mode: '0644'

opt_ldconfig:
  cmd.run:
    - name: ldconfig
    - onchanges:
      - file: opt_ld_conf
