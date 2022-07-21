change-resolv-conf:
  cmd.run:
    - name: echo "nameserver 172.30.5.32\nnameserver 172.30.5.33">/etc/resolv.conf

dns-in-interfaces:
  file.replace:
    - name: /etc/network/interfaces
    - pattern: ^dns-nameservers.*$
    - repl: dns-nameservers  172.30.5.32 172.30.5.33
