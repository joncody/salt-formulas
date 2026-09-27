nftables_pkg:
  pkg.installed:
    - name: nftables

nftables_conf:
  file.managed:
    - name: /etc/nftables.conf
    - source: salt://nftables/files/nftables.conf
    - user: root
    - group: root
    - mode: '0644'
    - check_cmd: /usr/sbin/nft -c -f
    - require:
      - pkg: nftables_pkg

nftables_service:
  service.running:
    - name: nftables
    - enable: True
    - watch:
      - file: nftables_conf
