# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nsd with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

nsd-config-file-file-managed:
  file.managed:
    - name: {{ nsd.config }}
    - source: {{ files_switch(['example.tmpl'],
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
    - context:
        nsd: {{ nsd | json }}
