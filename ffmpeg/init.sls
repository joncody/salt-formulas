{% from "ffmpeg/map.jinja" import ffmpeg with context %}

ffmpeg_deps:
  file.directory:
    - name: /opt/src
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

ffmpeg:
  pkg.installed:
    - names:
      - libmp3lame-dev
      - libvorbis-dev
      - libogg-dev
      - libxvidcore-dev
      - libtheora-dev
      - libx264-dev
      - libfaac-dev
      - libopus-dev
      - libpulse-dev
      - libspeex-dev
      - libvpx-dev
      - libwebp-dev
      - yasm
    - require:
      - file: ffmpeg_deps
  git.latest:
    - name: git://source.ffmpeg.org/ffmpeg.git
    - rev: master
    - target: /opt/src/ffmpeg
    - user: root
    - require:
      - pkg: ffmpeg
  cmd.run:
    - cwd: /opt/src/ffmpeg
    - name: ./configure --prefix=/opt/ffmpeg --enable-gpl --enable-nonfree --enable-libmp3lame --enable-libopus --enable-libpulse --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libwebp --enable-libxvid
    - require:
      - git: ffmpeg

ffmpeg-install:
  cmd.run:
    - cwd: /opt/src/ffmpeg
    - name: make install
    - require:
      - cmd: ffmpeg
