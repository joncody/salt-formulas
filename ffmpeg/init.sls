{% from "ffmpeg/map.jinja" import ffmpeg with context %}

include:
  - optsrc

ffmpeg:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - autotools-dev
      - build-essential
      - cmake
      - git
      - libevent-dev
      - libfaac-dev
      - libmp3lame-dev
      - libogg-dev
      - libopus-dev
      - libpulse-dev
      - libspeex-dev
      - libssl-dev
      - libtheora-dev
      - libtool
      - libvorbis-dev
      - libvpx-dev
      - libwebp-dev
      - libx264-dev
      - libxvidcore-dev
      - openssl
      - pkg-config
      - valgrind
      - yasm
    - require:
      - file: optsrc
  git.latest:
    - name: {{ ffmpeg.repo }}
    - branch: {{ ffmpeg.branch }}
    - rev: {{ ffmpeg.rev }}
    - target: /opt/src/ffmpeg
    - require:
      - pkg: ffmpeg
  cmd.run:
    - cwd: /opt/src/ffmpeg
    - name: ./configure --prefix=/opt/ffmpeg --enable-gpl --enable-nonfree --enable-libmp3lame --enable-libopus --enable-libpulse --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libwebp --enable-libxvid && make && make install && make clean
    - unless: test -d /opt/ffmpeg
    - require:
      - git: ffmpeg
