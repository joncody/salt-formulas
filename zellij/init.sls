{% from "zellij/map.jinja" import zellij with context %}

include:
  - optsrc

zellij_bin_dir:
  file.directory:
    - name: {{ zellij.prefix }}/bin
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

zellij_archive:
  archive.extracted:
    - name: {{ zellij.prefix }}/bin
    - source: https://github.com/zellij-org/zellij/releases/download/v{{ zellij.version }}/zellij-x86_64-unknown-linux-musl.tar.gz
    - skip_verify: True
    - archive_format: tar
    - enforce_toplevel: False
    - enforce_ownership_on: {{ zellij.prefix }}/bin
    - creates: {{ zellij.prefix }}/bin/zellij
    - require:
      - file: zellij_bin_dir
