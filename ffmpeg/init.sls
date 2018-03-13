{% from "ffmpeg/map.jinja" import ffmpeg with context %}

include:
  - optsrc

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
      - file: optsrc
  git.latest:
    - name: {{ ffmpeg.repo }}
    - branch: master
    - target: /opt/src/ffmpeg
    - require:
      - pkg: ffmpeg
  cmd.run:
    - cwd: /opt/src/ffmpeg
    - name: ./configure --prefix=/opt/ffmpeg --enable-gpl --enable-nonfree --enable-libmp3lame --enable-libopus --enable-libpulse --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libwebp --enable-libxvid && make && make install && make clean && ldconfig && source /etc/profile
    - unless: test -d /opt/ffmpeg
    - require:
      - git: ffmpeg
