bashrc:
  file.append:
    - name: /etc/bash.bashrc
    - ignore_whitespace: False
    - makedirs: True
    - source: salt://bashrc/files/custom.bashrc

sudoers:
  file.append:
    - name: /etc/sudoers
    - ignore_whitespace: False
    - makedirs: True
    - source: salt://bashrc/files/custom.sudoers
