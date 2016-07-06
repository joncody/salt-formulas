{% from "iptables/map.jinja" import iptables with context %}

include:
  - iptables

iptables-conf:
  file.managed:
    - name: {{ iptables.rules }}
    - source: salt://iptables/files/iptables.rules
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: iptables
  cmd.run:
    - cwd: /
    - name: iptables-restore < {{ iptables.rules }}
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: iptables-conf
