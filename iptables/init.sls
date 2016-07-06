{% from "iptables/map.jinja" import iptables with context %}

iptables:
  pkg.installed:
    - name: {{ iptables.package }}
