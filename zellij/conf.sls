zellij_system_conf:
  file.managed:
    - name: /etc/zellij/config.kdl
    - source: salt://zellij/files/config.kdl
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

zellij_system_layout:
  file.managed:
    - name: /etc/zellij/layouts/dev.kdl
    - source: salt://zellij/files/dev.kdl
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
