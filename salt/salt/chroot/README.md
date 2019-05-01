# Chroot

### Components
* debootstrap
* systemd-container
* lvm formula # Requerenment

### Configs
* ```/var/lib/machines/ # Chroot paths```
* ```/etc/systemd/nspawn/*.nspawn # Systemd drop-in for chroot paths```
* ```/var/lib/machines/{{ service }}/provisioner.sh # Chroot providioner```

### Grains
```yaml
services:
- blackis
- haproxy
- percona
- ...
```
Above services have to be defined in lvm pillar.
For more information about lvm pillar, Read the lvm README.
In the init.sls We generate a provisioner.sh script to bootstrap the container, do things like install salt and register in the salt master and etc.