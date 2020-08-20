{% from "caddy/map.jinja" import caddy with context %}

{% if salt.grains.get('os_family') == 'Debian' %}
provision_caddy_apt_repository:
  pkgrepo.managed:
    - humanname: Caddy package repository
    - name: deb [trusted=yes] {{ caddy.repo_url }} /
    - refresh_db: True
{% elif salt.grains.get('os_family') == 'RedHat' %}
provision_caddy_copr_repository:
  pkg.installed:
    - name: yum-plugin-copr
  cmd.run:
    - name: copr enable @caddy/caddy
{% endif %}
