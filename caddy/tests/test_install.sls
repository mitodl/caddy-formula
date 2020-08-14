{% from "caddy/map.jinja" import caddy with context %}

{% for pkg in caddy.pkgs %}
test_{{pkg}}_is_installed:
  testinfra.package:
    - name: {{ pkg }}
    - is_installed: True
{% endfor %}
