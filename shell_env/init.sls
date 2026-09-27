opt_profile_env:
  file.managed:
    - name: /etc/profile.d/opt_env.sh
    - source: salt://shell_env/files/opt_env.sh
    - user: root
    - group: root
    - mode: '0644'

opt_nushell_env_dir:
  file.directory:
    - name: /etc/nushell
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

opt_nushell_env:
  file.managed:
    - name: /etc/nushell/env.nu
    - source: salt://shell_env/files/env.nu
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - file: opt_nushell_env_dir
