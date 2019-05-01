echo "nameserver 172.30.5.32\nnameserver 172.30.5.33">/etc/resolv.conf:
  cmd.run

#dns-in-resolv:
    #    file.replace:
    #        - name: /etc/resolv.conf
    #      - pattern: ^nameserver\s*\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$
    #      - repl: nameserver  172.30.5.32   
