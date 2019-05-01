{% for lvms in pillar.get('lvm-pillar', {}) %}
  {% for service, size in lvms.items() %}
    {% if service in grains['services'] %}
      {% set block = service.replace('-', '--') %}
      /var/lib/{{ service }}:
        file.directory:
          - makedirs: True
          - user: root
          - group: root
          - recurse:
            - user
            - group
      {{ service }}-lvm:
        lvm.lv_present:
          - name: {{ service }}
          - vgname: debian
          - size: {{ size }}g
        blockdev.formatted:
          - name: /dev/mapper/debian-{{ block }}
          - force: true
          - fs_type: ext4
        mount.mounted:
          - name: /var/lib/{{ service }}
          - device: /dev/mapper/debian-{{ block }}
          - fstype: ext4
          - mkmnt: True
          - opts:
            - defaults
    {% endif %}
  {% endfor %}
{% endfor %}
