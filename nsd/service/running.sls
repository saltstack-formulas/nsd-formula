# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nsd with context %}

include:
  - {{ sls_config_file }}

nsd-service-running-service-running:
  service.running:
    - name: {{ nsd.service.name }}
    - enable: True
    - require:
      - cmd: nsd-service-control-setup-control
