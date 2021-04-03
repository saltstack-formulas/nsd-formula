# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nsd with context %}

{%- set config_dir = salt.file.dirname(nsd.config) %}

include:
  - {{ sls_config_file }}

nsd-service-control-setup-control:
  cmd.run:
    - name: nsd-control-setup
    - creates: {{ config_dir }}/nsd_server.pem
