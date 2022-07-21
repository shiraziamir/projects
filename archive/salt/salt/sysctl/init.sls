{% for sysctl in pillar.get('sysctl-pillar', {}) %}
  {% for key, value in sysctl.items() %}
        {{ key }}:
          sysctl.present:
            - value: {{ value }}
  {% endfor %}
{% endfor %}
