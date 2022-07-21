docker-repo:
  pkgrepo.managed:
    - humanname: Docker repo
    - name: deb http://reg.d.com/docker stretch stable
    - key_url: http://reg.d.com/keys/docker.gpg

docker-ce:
  pkg:
    - installed
    - require:
      - pkgrepo: docker-repo

/etc/systemd/system/docker.service.d:
  file.recurse:
    - source: salt://docker/systemd/
    - template: jinja
    - makedirs: True
    - require:
      - pkg: docker-ce

/etc/docker/daemon.json:
  file.managed:
    - source: salt://docker/daemon.json
    - template: jinja
    - require:
      - pkg: docker-ce

{% if not grains.has_key('docker-provisioned') %}
service.systemctl_reload:
  module.run:
    - onchanges:
      - file: /etc/systemd/system/docker.service.d
    - require:
      - pkg: docker-ce

docker-config-service:
  service.running:
    - name: docker
    - restart: True
    - makedirs: True
    - require:
      - pkg: docker-ce
    - watch:
      - file: /etc/docker/daemon.json

grains.set:
  module.run:
    - key: docker-provisioned
    - val: true
{% endif %}

/usr/local/bin/docker-compose:
  file.managed:
    - source: http://reg.d.com/pkgs/docker/docker-compose
    - source_hash: http://reg.d.com/pkgs/docker/docker-compose.hash
    - mode: 755
    - makedirs: True
    - require:
      - pkg: docker-ce