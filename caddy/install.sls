{% from "caddy/map.jinja" import caddy with context %}

include:
  - .service

caddy:
  pkg.installed:
    - pkgs: {{ caddy.pkgs }}
    - require_in:
        - service: caddy_service_running
