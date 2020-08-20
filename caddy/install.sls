{% from "caddy/map.jinja" import caddy with context %}

include:
  - .service
{% if caddy.install_from_repo %}
  - .pkg_repo

install_caddy_package:
  pkg.installed:
    - name: caddy
    - require_in:
        - service: caddy_service_running
    - require:
        - pkgrepo: provision_caddy_apt_repository
{% else %}
create_caddy_user:
  user.present:
    - name: {{ caddy.user }}
    - usergroup: True
    - createhome: False
    - system: True

download_caddy_binary:
  archive.extracted:
    - name: /usr/local/bin/
    - source: {{ caddy.download_url }}/v{{ caddy.version }}/caddy_{{ caddy.version }}_linux_{{ salt.grains.get('osarch') }}
    - source_hash: {{ caddy.download_url }}/v{{ caddy.version }}/caddy_{{ caddy.version }}_checksums.txt

create_caddy_config_directory:
  file.directory:
    - name: /etc/caddy/
    - user: {{ caddy.user }}
    - recurse:
        - user

create_caddy_data_directory:
  file.directory:
    - name: /var/lib/caddy/
    - user: {{ caddy.user }}
    - recurse:
        - user
{% endif %}

create_caddy_service_definition:
  file.managed:
    {% if caddy.install_from_repo %}
    - name: /etc/systemd/system/caddy.service.d/override.conf
    - source: salt://caddy/templates/caddy.service.override
    {% else %}
    - name: /etc/systemd/system/caddy.service
    - source: salt://caddy/templates/caddy.service
    {% endif %}
    - template: jinja
    - context:
        enable_api: {{ caddy.enable_api }}
        config_file: {{ caddy.config_file }}
    - require_in:
        - service: caddy_service_running
  cmd.run:
    - name: systemctl daemon-reload
    - require_in:
        - service: caddy_service_running
