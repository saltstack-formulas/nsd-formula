# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nsd with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- from tplroot ~ "/macros.jinja" import config_file with context %}
{%- from tplroot ~ "/macros.jinja" import zonefile_name with context %}

{%- set zones = nsd.get('zones', {}) %}

{%- if zones | length > 0 %}

{{    config_file('90-generated-zones', 'generated-zones') }}

nsd-config-zones-file-directory:
  file.directory:
    - name: {{ nsd.zones_dir }}
    - makedirs: True

{%-   for name, config in zones.items() %}

{%-     set identifier = 'nsd-config-zones-file-managed-'+name %}
{%-     set template = 'zones/'+name+'.zone' %}

"{{ identifier }}":
  file.managed:
    - name: "{{ nsd.zones_dir }}/{{ zonefile_name(name, config) }}"
    - source: {{ files_switch([template, template+'.jinja'],
                              lookup=identifier
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ nsd.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        nsd: {{ nsd | json }}
    - check_cmd: nsd-checkzone "{{ name }}"
    - require:
      - file: nsd-config-zones-file-directory
    - require_in:
      - service: nsd-service-running-service-running
    - onchanges_in:
      - cmd: nsd-service-control-reload-zones

{%-   endfor %}
{%- endif %}
