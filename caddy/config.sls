{% from "caddy/map.jinja" import caddy with context %}

include:
  - .install
  - .service

caddy-config:
  file.managed:
    - name: {{ caddy.conf_file }}
    - source: salt://caddy/templates/conf.jinja
    - template: jinja
    - watch_in:
      - service: caddy_service_running
    - require:
      - pkg: caddy
