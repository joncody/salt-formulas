alacritty_system_conf:
  file.managed:
    - name: /etc/alacritty/alacritty.toml
    - source: salt://alacritty/files/alacritty.toml
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
