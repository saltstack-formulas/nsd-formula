# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nsd with context %}

nsd-package-install-pkg-installed:
  pkg.installed:
    - name: {{ nsd.pkg.name }}
