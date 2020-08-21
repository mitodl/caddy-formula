{% from "caddy/map.jinja" import caddy with context %}
{% if caddy.enable_api and caddy.install_from_repo %}
{% set service_name = 'caddy-api' %}
{% else %}
{% set service_name = 'caddy' %}
{% endif %}

caddy_service_running:
  service.running:
    - name: {{ service_name }}
    - enable: True
    - reload: True
