# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nsd with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- for name, template in nsd.get('config_files', {}).items() %}

{%-   set identifier = 'nsd-config-config_files-file-managed-'+name %}

"{{ identifier }}":
  file.managed:
    - name: "{{ nsd.config_include_dir }}/{{ name }}.conf"
    - source: {{ files_switch([template+'.conf', template+'.conf.jinja'],
                              lookup=identifier
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ nsd.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - file: nsd-config-include-file-directory
    - require_in:
      - file: nsd-config-file-file-managed
    - context:
        nsd: {{ nsd | json }}
    - check_cmd: nsd-checkconf

{%- endfor %}
