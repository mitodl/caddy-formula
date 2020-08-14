{% from "caddy/map.jinja" import caddy with context %}

caddy_service_running:
  service.running:
    - name: {{ caddy.service }}
    - enable: True
