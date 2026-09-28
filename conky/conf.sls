conky_etc_dir:
  file.directory:
    - name: /etc/conky
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

conky_system_conf:
  file.managed:
    - name: /etc/conky/conky.conf
    - source: salt://conky/files/conky.conf
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - file: conky_etc_dir

conky_xdg_dir:
  file.directory:
    - name: /etc/xdg/conky
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

conky_xdg_symlink:
  file.symlink:
    - name: /etc/xdg/conky/conky.conf
    - target: /etc/conky/conky.conf
    - force: True
    - require:
      - file: conky_system_conf
      - file: conky_xdg_dir
