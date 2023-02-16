# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/macros.jinja" import config_file with context %}
{%- from tplroot ~ "/map.jinja" import mapdata as nsd with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

nsd-config-file-file-managed:
  file.managed:
    - name: {{ nsd.config }}
    - source: {{ files_switch(['nsd.conf', 'nsd.conf.jinja'],
                              lookup='nsd-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ nsd.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
      - file: nsd-config-include-file-directory
    - context:
        nsd: {{ nsd | json }}
    - check_cmd: nsd-checkconf

{%- set config_data = nsd.get('config_data', {}) %}

{%- if config_data | length > 0 %}

{{    config_file('10-salt', 'pillar-configuration') }}

{%- endif %}

