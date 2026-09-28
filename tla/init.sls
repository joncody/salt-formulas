{% from "tla/map.jinja" import tla with context %}

include:
  - optsrc

tla_deps:
  pkg.installed:
    - name: default-jre-headless
    - require:
      - file: optsrc

tla_dirs:
  file.directory:
    - names:
      - {{ tla.prefix }}
      - {{ tla.prefix }}/lib
      - {{ tla.prefix }}/bin
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True
    - require:
      - file: optsrc

tla_jar:
  file.managed:
    - name: {{ tla.prefix }}/lib/tla2tools.jar
    - source: https://github.com/tlaplus/tlaplus/releases/download/v{{ tla.version }}/tla2tools.jar
    - skip_verify: True
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - file: tla_dirs
      - pkg: tla_deps

tla_tlc:
  file.managed:
    - name: {{ tla.prefix }}/bin/tlc
    - contents: |
        #!/bin/sh
        exec java ${TLA_JVM_OPTS:--XX:+UseParallelGC} -cp {{ tla.prefix }}/lib/tla2tools.jar tlc2.TLC "$@"
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - file: tla_dirs

tla_sany:
  file.managed:
    - name: {{ tla.prefix }}/bin/sany
    - contents: |
        #!/bin/sh
        exec java ${TLA_JVM_OPTS} -cp {{ tla.prefix }}/lib/tla2tools.jar tla2sany.SANY "$@"
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - file: tla_dirs

tla_pcal:
  file.managed:
    - name: {{ tla.prefix }}/bin/pcal
    - contents: |
        #!/bin/sh
        exec java ${TLA_JVM_OPTS} -cp {{ tla.prefix }}/lib/tla2tools.jar pcal.trans "$@"
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - file: tla_dirs

tla_repl:
  file.managed:
    - name: {{ tla.prefix }}/bin/tla-repl
    - contents: |
        #!/bin/sh
        exec java ${TLA_JVM_OPTS} -cp {{ tla.prefix }}/lib/tla2tools.jar tlc2.REPL "$@"
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - file: tla_dirs
