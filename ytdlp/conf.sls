ytdlp_conf:
  file.managed:
    - name: /etc/yt-dlp.conf
    - source: salt://ytdlp/files/yt-dlp.conf
    - user: root
    - group: root
    - mode: '0644'
