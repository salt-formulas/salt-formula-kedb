{%- from "kedb/map.jinja" import server with context %}

kedb_debconf:
  debconf.set:
  - name: kedb
  - data:
      'kedb/user':
        type: string
        value: {{ server.user }}
      'kedb/group':
        type: string
        value: {{ server.group }}
      'kedb/bind_host':
        type: string
        value: {{ server.bind.address }}
      'kedb/bind_port':
        type: string
        value: {{ server.bind.port }}
      'kedb/workers':
        type: string
        value: '{{ server.get('workers', grains.num_cpus * 2 + 1) }}'
      'kedb/log_level':
        type: string
        value: {{ server.log_level }}

kedb_packages:
  pkg.installed:
  - names: {{ server.pkgs }}
  - require:
    - debconf: kedb_debconf
  - require_in:
    - file: django_conf_settings
    - cmd: django_migrate_database
