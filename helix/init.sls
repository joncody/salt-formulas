{% from "helix/map.jinja" import helix with context %}

include:
  - optsrc

helix_dir:
  file.directory:
    - name: {{ helix.prefix }}
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

helix_archive:
  archive.extracted:
    - name: {{ helix.prefix }}
    - source: https://github.com/helix-editor/helix/releases/download/{{ helix.version }}/helix-{{ helix.version }}-x86_64-linux.tar.xz
    - skip_verify: True
    - archive_format: tar
    - options: "--strip-components=1"
    - enforce_toplevel: False
    - enforce_ownership_on: {{ helix.prefix }}
    - creates: {{ helix.prefix }}/hx
    - require:
      - file: helix_dir

helix_bin_dir:
  file.directory:
    - name: {{ helix.prefix }}/bin
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

helix_symlink:
  file.symlink:
    - name: {{ helix.prefix }}/bin/hx
    - target: {{ helix.prefix }}/hx
    - force: True
    - require:
      - archive: helix_archive
      - file: helix_bin_dir
