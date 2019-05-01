{% for lvms in pillar.get('lvm-pillar-us', {}) %}
  {% for service, size in lvms.items() %}
    {% if service in grains['services'] %}
      {% set block = service.replace('-', '--') + '--us' %}
      {{ service }}-lvm-us:
        lvm.lv_present:
          - name: {{ service }}-us
          - vgname: debian
          - size: {{ size }}g

        blockdev.formatted:
          - name: /dev/mapper/debian-{{ block }}
          - fs_type: ext4
        mount.mounted:
          - name: /var/lib/machines/{{ service }}
          - device: /dev/mapper/debian-{{ block }}
          - fstype: ext4
          - mkmnt: True
          - opts:
            - defaults
    {% endif %}
  {% endfor %}
{% endfor %}
{% for lvms in pillar.get('lvm-pillar-data', {}) %}
  {% for service, size in lvms.items() %}
    {% if service in grains['services'] %}
      {% set block = service.replace('-', '--') + '--data' %}
      {{ service }}-lvm-data:
        lvm.lv_present:
          - name: {{ service }}-data
          - vgname: debian
          - size: {{ size }}g
        blockdev.formatted:
          - name: /dev/mapper/debian-{{ block }}
          - force: true
          - fs_type: ext4
        mount.mounted:
          - name: /var/lib/machines/{{ service }}/var/lib/{{ service }}
          - device: /dev/mapper/debian-{{ block }}
          - fstype: ext4
          - mkmnt: True
          - opts:
            - defaults
    {% endif %}
  {% endfor %}
{% endfor %}
