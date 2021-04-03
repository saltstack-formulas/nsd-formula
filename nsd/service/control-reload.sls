# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nsd with context %}

{%- set config_dir = salt.file.dirname(nsd.config) %}

include:
  - {{ sls_config_file }}
  - {{ sls_service_running }}

nsd-service-control-reload-zones:
  cmd.run:
    - name: nsd-control reload
    - onchanges:
      - service: nsd-service-running-service-running
    - require:
      - service: nsd-service-running-service-running
      - cmd: nsd-service-control-setup-control
