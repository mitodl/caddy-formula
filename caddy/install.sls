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
    - source: {{ caddy.download_url }}/v{{ caddy.version }}/caddy_{{ caddy.version }}_linux_amd64.tar.gz
    - source_hash: {{ caddy.download_url }}/v{{ caddy.version }}/caddy_{{ caddy.version }}_checksums.txt
    - enforce_toplevel: False
  file.managed:
    - name: /usr/local/bin/caddy
    - mode: '0755'
    - require:
        - archive: download_caddy_binary
    - require_in:
        - service: caddy_service_running

create_caddy_config_directory:
  file.directory:
    - name: /etc/caddy/
    - user: {{ caddy.user }}
    - recurse:
        - user
    - require:
        - user: create_caddy_user
    - require_in:
        - service: caddy_service_running

create_caddy_data_directory:
  file.directory:
    - name: {{ caddy.data_dir }}
    - user: {{ caddy.user }}
    - recurse:
        - user
    - require:
        - user: create_caddy_user
    - require_in:
        - service: caddy_service_running

create_caddy_log_directory:
  file.directory:
    - name: {{ caddy.log_dir }}
    - user: {{ caddy.user }}
    - recurse:
        - user
    - require:
        - user: create_caddy_user
    - require_in:
        - service: caddy_service_running
{% endif %}

create_caddy_service_definition:
  file.managed:
    {% if caddy.install_from_repo %}
    - name: /etc/systemd/system/caddy.service.d/override.conf
    - source: salt://caddy/templates/caddy.service.override
    - makedirs: True
    {% else %}
    - name: /etc/systemd/system/caddy.service
    - source: salt://caddy/templates/caddy.service
    {% endif %}
    - template: jinja
    - context:
        enable_api: {{ caddy.enable_api }}
        config_file: {{ caddy.config_file }}
        user: {{ caddy.user }}
    - require_in:
        - service: caddy_service_running
  cmd.run:
    - name: systemctl daemon-reload
    - require_in:
        - service: caddy_service_running
