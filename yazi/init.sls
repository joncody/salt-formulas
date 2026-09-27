{% from "yazi/map.jinja" import yazi with context %}

include:
  - optsrc

yazi_deps:
  pkg.installed:
    - name: unzip

yazi_bin_dir:
  file.directory:
    - name: {{ yazi.prefix }}/bin
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

yazi_archive:
  archive.extracted:
    - name: {{ yazi.prefix }}/bin
    - source: https://github.com/sxyazi/yazi/releases/download/v{{ yazi.version }}/yazi-x86_64-unknown-linux-musl.zip
    - skip_verify: True
    - archive_format: zip
    - options: "-j"
    - enforce_toplevel: False
    - enforce_ownership_on: {{ yazi.prefix }}/bin
    - creates: {{ yazi.prefix }}/bin/yazi
    - require:
      - file: yazi_bin_dir
      - pkg: yazi_deps
