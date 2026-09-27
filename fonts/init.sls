{% from "fonts/map.jinja" import fonts with context %}

fonts_deps:
  pkg.installed:
    - names:
      - fontconfig
      - unzip

hack_nerd_font_dir:
  file.directory:
    - name: {{ fonts.font_dir }}
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

hack_nerd_font_archive:
  archive.extracted:
    - name: {{ fonts.font_dir }}
    - source: https://github.com/ryanoasis/nerd-fonts/releases/download/v{{ fonts.version }}/Hack.zip
    - skip_verify: True
    - archive_format: zip
    - enforce_toplevel: False
    - creates: {{ fonts.font_dir }}/HackNerdFont-Regular.ttf
    - require:
      - file: hack_nerd_font_dir
      - pkg: fonts_deps

refresh_font_cache:
  cmd.run:
    - name: fc-cache -f
    - onchanges:
      - archive: hack_nerd_font_archive
