freeipa-client-deps:
   pkg.installed:
     - pkgs:
       - adcli
       - bind9utils
       - certmonger
       - cracklib-runtime
       - curl
       - dnsutils
       - krb5-config
       - krb5-user
       - ldap-utils
       - libbasicobjects0
       - libc-ares2
       - libcollection4
       - libcrack2
       - libcurl3
       - libcurl3-nss
       - libdhash1
       - libhttp-parser2.1
       - libini-config5
       - libjansson4
       - libldb1
       - libnl-3-200
       - libnl-route-3-200
       - libnss-sss
       - libnss3-tools
       - libpam-pwquality
       - libpam-sss
       - libpath-utils1
       - libpwquality-common
       - libpwquality1
       - libref-array1
       - libsasl2-modules-gssapi-mit
       - libsmbclient
       - libsss-idmap0
       - libsss-nss-idmap0
       - libsss-sudo
       - libtalloc2
       - libtdb1
       - libtevent0
       - libwbclient0
       - libxmlrpc-core-c3
       - oddjob
       - oddjob-mkhomedir
       - python-sss
       - python-talloc
       - samba-libs
       - sssd
       - sssd-ad
       - sssd-ad-common
       - sssd-common
       - sssd-ipa
       - sssd-krb5
       - sssd-krb5-common
       - sssd-ldap
       - sssd-proxy
       - python-gssapi
       - python-dnspython
       - python-ldap
       - gnupg2
       - keyutils
       - python-cffi
       - python-custodia
       - python-dbus
       - python-jwcrypto
       - python-ldap
       - python-libipa-hbac
       - python-lxml
       - python-memcache
       - python-netaddr
       - python-netifaces
       - python-nss
       - python-qrcode
       - python-usb
       - python-yubico
       - sssd-tools
       - ntp

install-freeipa-client:
  pkg.installed:
    - sources:
      - python-ipalib: http://reg.d.com/pkgs/freeipa-client/python-ipalib_4.4.4-3_all.deb
      - python-ipaclient: http://reg.d.com/pkgs/freeipa-client/python-ipaclient_4.4.4-3_all.deb
      - freeipa-common: http://reg.d.com/pkgs/freeipa-client/freeipa-common_4.4.4-3_all.deb
      - freeipa-client: http://reg.d.com/pkgs/freeipa-client/freeipa-client_4.4.4-3_amd64.deb
    - require:
      - pkg: freeipa-client-deps

join-domain:
  cmd.run:
    - name: ipa-client-install --domain={{ pillar['freeipa-client-pillar']['domain'] }} --server={{ pillar['freeipa-client-pillar']['server'] }} --realm={{ pillar['freeipa-client-pillar']['realm'] }} --principal={{ pillar['freeipa-client-pillar']['user'] }} --password={{ pillar['freeipa-client-pillar']['pass'] }} --mkhomedir --ntp-server={{ pillar['freeipa-client-pillar']['ntp'] }} -U 2>&1 | if grep "IPA client is already configublack on this system"; then true; fi
    - require:
      - pkg: install-freeipa-client

sudo_refresh_time:
  cmd.run:
    - name: if ! grep "ldap_sudo_smart_refresh_interval" /etc/sssd/sssd.conf >/dev/null ; then sed -i '/\[domain\/{{ pillar['freeipa-client-pillar']['domain'] }}\]/a ldap_sudo_smart_refresh_interval = {{ pillar['freeipa-client-pillar']['smart-refresh'] }}\nldap_sudo_full_refresh_interval = {{ pillar['freeipa-client-pillar']['full-refresh'] }}' /etc/sssd/sssd.conf; fi

fix_sssd_services:
  cmd.run:
    - name: if ! grep "services = nss, pam, ssh, sudo" /etc/sssd/sssd.conf >/dev/null ; then sed -i -e 's/services =.*/services = nss, pam, ssh, sudo/' /etc/sssd/sssd.conf && systemctl restart sssd; fi

mkhomedir:
  file.append:
    - name: /etc/pam.d/common-session
    - text: session     optional        pam_mkhomedir.so skel=/etc/skel umask=0022
