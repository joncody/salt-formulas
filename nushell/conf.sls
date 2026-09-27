nushell_system_config:
  file.managed:
    - name: /etc/nushell/config.nu
    - source: salt://nushell/files/config.nu
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

nushell_system_env:
  file.managed:
    - name: /etc/nushell/env.nu
    - source: salt://nushell/files/env.nu
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
