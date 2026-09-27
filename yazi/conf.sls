yazi_system_conf:
  file.managed:
    - name: /etc/xdg/yazi/yazi.toml
    - source: salt://yazi/files/yazi.toml
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True
