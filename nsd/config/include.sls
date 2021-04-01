# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nsd with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

nsd-config-include-file-directory:
  file.directory:
    - name: "{{ nsd.config_include_dir }}"
    - makedirs: true
