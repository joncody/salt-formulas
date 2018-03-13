bashrc:
  file.append:
    - name: /etc/bash.bashrc
    - ignore_whitespace: False
    - makedirs: True
    - source: salt://bashrc/custom.bashrc
