#!pyobjects
import json

caddy = salt.jinja.load_map('caddy/map.jinja', 'caddy')

include('.service')

File.managed('write_caddy_config',
             name=caddy['config_file'],
             contents=json.dumps(caddy['config'], indent=2, sort_keys=True),
             makedirs=True,
             user=caddy['user'],
             watch_in=[Service('caddy_service_running')])
