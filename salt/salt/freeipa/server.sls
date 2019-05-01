freeipa-server:
  file:
    - managed
    - name: /docker/freeipa-server/docker-compose.yml
    - makedirs: True
    - user: root
    - group: root
    - contents: |
        version: "3"
        services:
          freeipa-server-container:
            image: freeipa/freeipa-server
            hostname: ipa
            domainname: d.local
            volumes:
              - /sys/fs/cgroup:/sys/fs/cgroup:ro
              - /var/lib/ipa-data:/data:Z
              - /etc/localtime:/etc/localtime:ro
            tmpfs:
              - /run
              - /tmp
            network_mode: "host"
            command: --ip-address={{ pillar['freeipa-server-pillar']['serverip'] }} --hostname={{ pillar['freeipa-server-pillar']['server'] }} --domain={{ pillar['freeipa-server-pillar']['domain'] }} --realm={{ pillar['freeipa-server-pillar']['realm'] }} --ds-password='{{ pillar['freeipa-server-pillar']['ds-pass'] }}' --admin-password='{{ pillar['freeipa-server-pillar']['admin-pass'] }}' --no-host-dns --no-ntp --unattended
start-freeipa:
  cmd.run:
    - name: docker-compose up -d
    - cwd: /docker/freeipa-server/
    - require:
      - file: freeipa-server
