# 1. POSIX login environment
opt_profile_env:
  file.managed:
    - name: /etc/profile.d/opt_env.sh
    - source: salt://shell_env/files/opt_env.sh
    - user: root
    - group: root
    - mode: '0644'

# 1b. Ensure non-login interactive bash shells also source opt_env.sh
opt_bashrc_source:
  file.append:
    - name: /etc/bash.bashrc
    - text: |
        # Load system-wide /opt environment for non-login shells
        if [ -f /etc/profile.d/opt_env.sh ]; then
            . /etc/profile.d/opt_env.sh
        fi

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

# 3. Modern CLI Tools (bat, eza, fd)
modern_cli_pkgs:
  pkg.installed:
    - names:
      - bat
      - eza
      - fd-find

# Symlinks to restore upstream binary names on Debian/Ubuntu
bat_symlink:
  file.symlink:
    - name: /usr/local/bin/bat
    - target: /usr/bin/batcat
    - onlyif: test -f /usr/bin/batcat
    - require:
      - pkg: modern_cli_pkgs

fd_symlink:
  file.symlink:
    - name: /usr/local/bin/fd
    - target: /usr/bin/fdfind
    - onlyif: test -f /usr/bin/fdfind
    - require:
      - pkg: modern_cli_pkgs

# Global bat configuration (Gruvbox Light Workstation)
bat_system_config:
  file.managed:
    - name: /etc/bat/config
    - contents: |
        --theme="gruvbox-light"
        --style="numbers,changes"
        --paging=never
    - makedirs: True
    - user: root
    - group: root
    - mode: '0644'
