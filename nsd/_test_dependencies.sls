{%- if grains['os_family'] == 'RedHat' or grains['os_family'] == 'Suse' %}
{%-   set package = 'bind-utils' %}
{%- elif grains['os_family'] == 'Arch' %}
{%-   set package = 'bind-tools' %}
{%- else %}
{%    set package = 'dnsutils' %}
{%- endif %}

nsd-_test_dependencies--package--installed:
  pkg.installed:
    - name: {{ package }}
