{% from "ffmpeg/map.jinja" import ffmpeg with context %}

include:
  - optsrc

ffmpeg_deps:
  pkg.installed:
    - names:
      - autoconf
      - automake
      - build-essential
      - cmake
      - git
      - libevent-dev
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
      - nasm
      - pkg-config
      - yasm
    - require:
      - file: optsrc

ffmpeg_git:
  git.latest:
    - name: {{ ffmpeg.repo }}
    - branch: {{ ffmpeg.branch }}
    - rev: {{ ffmpeg.rev }}
    - target: /opt/src/ffmpeg
    - require:
      - pkg: ffmpeg_deps

ffmpeg_build:
  cmd.run:
    - cwd: /opt/src/ffmpeg
    - name: |
        ./configure --prefix={{ ffmpeg.prefix }} --enable-gpl --enable-nonfree --enable-libmp3lame --enable-libopus --enable-libpulse --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libwebp --enable-libxvid
        make -j{{ grains['num_cpus'] }}
        make install
        make clean
    - onchanges:
      - git: ffmpeg_git
    - creates: {{ ffmpeg.prefix }}/bin/ffmpeg
