base_repo:
  pkgrepo.managed:
    - humanname: HPE
    - name: deb http://downloads.linux.hpe.com/SDR/repo/mcp stretch/current non-free
    - file: /etc/apt/sources.list.d/hpe.list
    - keyid:  C208ADDE26C2B797
    - keyserver: keyserver.ubuntu.com

cli_pakages:
  pkg.installed:
    - pkgs:
      - ssacli


install-old-client:
    pkg.installed:
      - sources:
        - hpssacli:  http://reg.d.com/pkgs/hpssacli/hpssacli-2.40-13.0_amd64.deb

/usr/local/bin/hp_cli.sh:
  file.managed:
    - source: salt://hpcli/hpe_cli.sh

