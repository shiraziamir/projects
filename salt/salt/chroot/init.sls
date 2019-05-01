container-pkgs:
   pkg.installed:
     - pkgs:
       - debootstrap
       - systemd-container

nspawn-unit:
  service.running:
      - enable: true
      - name: machines.target
      - require:
        - pkg: container-pkgs

{% for service in grains['services'] %}
{% if not salt['file.directory_exists' ]('/var/lib/machines/'+service+'/etc') %}
{{ service }}-chroot:
  cmd.run:
    - name: debootstrap --variant=minbase --include=systemd,dbus,curl,gnupg,iproute2,git,apt-transport-https,sudo --arch amd64 stretch /var/lib/machines/{{ service }} http://reg.d.com/debian/
    - require:
      - service: nspawn-unit
{% endif %}

{{ service }}-override:
  file:
    - managed
    - name: /etc/systemd/nspawn/{{ service }}.nspawn
    - user: root
    - group: root
    - makedirs: True
    - contents: |
        [Exec]
        Capability=CAP_NET_BIND_SERVICE
        PrivateUsers=no
        [Network]
        Private=no
        VirtualEthernet=no

{{ service }}-unit:
  service.running:
    - enable: true
    - name: systemd-nspawn@{{ service }}
    - watch:
      - file: /etc/systemd/nspawn/{{ service }}.nspawn

{% if not salt['file.file_exists' ]('/var/lib/machines/'+service+'/provisioner.sh') %}
{{ service }}-hostnmae:
  cmd.run:
    - name: echo "{{ service }}.`hostname`" > /var/lib/machines/{{ service }}/etc/hostname
          
{{ service }}-install-salt:
  file:
      - managed
      - name: /var/lib/machines/{{ service }}/provisioner.sh
      - user: root
      - group: root
      - contents: |
          hostnamectl set-hostname `cat /etc/hostname`
          echo "127.0.0.1 localhost" > /etc/hosts
          echo "127.0.1.1 `hostname`" >> /etc/hosts
          echo -e "deb http://reg.d.com/debian stretch main\ndeb http://reg.d.com/debian stretch-updates main\ndeb http://reg.d.com/backports stretch-backports main\ndeb http://reg.d.com/debian-security stretch/updates main" > /etc/apt/sources.list
          echo "deb http://reg.d.com/salt stretch main" > /etc/apt/sources.list.d/salt.list
          curl http://reg.d.com/keys/SALTSTACK-GPG-KEY.pub | apt-key add
          apt-get update
          apt-get install -o Dpkg::Options::="--force-confdef" -y salt-minion
          echo "master: salt.d.com" > /etc/salt/minion
          systemctl restart salt-minion
      - require:
        - service: {{ service }}-unit
  cmd.run:
    - name: sleep 10 && machinectl shell {{ service }} /bin/bash /provisioner.sh
{% endif %}
{% endfor %}
