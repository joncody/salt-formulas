bashrc:
  file.append:
    - name: /home/jd/test.txt
    - ignore_whitespace: False
    - makedirs: True
    - source: salt://bashrc/custom.bashrc
