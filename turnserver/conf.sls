{% from "turnserver/map.jinja" import turnserver with context %}

include:
  - turnserver

turnserver-conf:
  file.managed:
    - name: {{ turnserver.conf }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://turnserver/files/turnserver.conf
    - require:
      - cmd: turnserver-build

turnuserdb-conf:
  file.managed:
    - name: {{ turnserver.userdb }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://turnserver/files/turnuserdb.conf
    - require:
      - file: turnserver-conf
