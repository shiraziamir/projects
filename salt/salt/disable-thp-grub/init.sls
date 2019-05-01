disable-thp-grub:
  cmd.run:
    - name: sed -ri.bak 's/GRUB_CMDLINE_LINUX_DEFAULT="[a-zA-Z0-9_= ]*/& transparent_hugepage=never/' /etc/default/grub && update-grub

echo never>/sys/kernel/mm/transparent_hugepage/enabled:
  cmd.run

