docker_deps:
  pkg.installed:
    - names:
      - ca-certificates
      - curl

docker_keyring_dir:
  file.directory:
    - name: /etc/apt/keyrings
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

docker_gpg_key:
  cmd.run:
    - name: curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && chmod a+r /etc/apt/keyrings/docker.asc
    - creates: /etc/apt/keyrings/docker.asc
    - require:
      - file: docker_keyring_dir
      - pkg: docker_deps

docker_repo:
  pkgrepo.managed:
    - name: deb [arch={{ grains['osarch'] }} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu {{ grains['oscodename'] }} stable
    - file: /etc/apt/sources.list.d/docker.list
    - clean_file: True
    - require:
      - cmd: docker_gpg_key

docker_pkgs:
  pkg.installed:
    - names:
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-buildx-plugin
      - docker-compose-plugin
    - require:
      - pkgrepo: docker_repo

docker_service:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: docker_pkgs
