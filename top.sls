base:
  '*':
    # --- Base System & Container / Network Infrastructure ---
    - optsrc
    - shell_env
    - nftables
    - docker

    # --- Core Language Toolchains ---
    - rust
    - go
    - node

    # --- Cryptographic & C Messaging Stack ---
    - sodium
    - zmq
    - czmq
    - zyre
    - filemq
    - asr

    # --- Storage & Server Daemons ---
    - postgresql
    - nginx
    - opensmtpd
    - dovecot
    - pureftpd

    # --- Terminal & Interactive Workspace ---
    - fonts
    - alacritty
    - helix
    - nushell
    - yazi
    - zellij

    # --- Desktop Utilities & Formal Verification ---
    - conky
    - ffmpeg
    - ytdlp
    - tla
