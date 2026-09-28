helix_system_conf:
  file.managed:
    - name: /etc/xdg/helix/config.toml
    - source: salt://helix/files/config.toml
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

helix_system_languages:
  file.managed:
    - name: /etc/xdg/helix/languages.toml
    - source: salt://helix/files/languages.toml
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
