remove_ntpd:
  pkg.removed:
  - name: ntp

#service.systemctl_reload:
 #  module.run:
 #    - onchanges:
   #     - file: /etc/systemd/system/systemd-timesyncd.service.d

#/etc/systemd/system/systemd-timesyncd.service.d:
  #  file.recurse:
    #    - source: salt://ntp/systemd/
    #  - makedirs: True

/etc/systemd/timesyncd.conf:
  file.managed:
    - source: salt://ntp/timesyncd.conf
    - template: jinja

timesyncd-config:
  service.running:
    - name: systemd-timesyncd
    - enable: True
    - restart: True
    - watch:
      - file: /etc/systemd/timesyncd.conf
enable-ntp:
  cmd.run:
    - name: timedatectl set-ntp true
