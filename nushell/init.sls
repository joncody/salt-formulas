{% from "nushell/map.jinja" import nushell with context %}

include:
  - optsrc

nushell_bin_dir:
  file.directory:
    - name: {{ nushell.prefix }}/bin
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

nushell_archive:
  archive.extracted:
    - name: {{ nushell.prefix }}/bin
    - source: https://github.com/nushell/nushell/releases/download/{{ nushell.version }}/nu-{{ nushell.version }}-x86_64-unknown-linux-musl.tar.gz
    - skip_verify: True
    - archive_format: tar
    - options: "--strip-components=1"
    - enforce_ownership_on: {{ nushell.prefix }}/bin
    - creates: {{ nushell.prefix }}/bin/nu
    - require:
      - file: nushell_bin_dir
