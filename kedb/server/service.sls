{%- from "kedb/map.jinja" import server with context %}
{%- if server.enabled %}

include:
{%- if server.source.engine == 'git' %}
- kedb.server._git_setup
{%- else %}
- kedb.server._pkg_setup
{%- endif %}

django_conf_settings:
  file.managed:
  - name: /etc/kedb/settings.py
  - user: root
  - group: kedb
  - source: salt://kedb/files/settings.py
  - template: jinja
  - mode: 640

django_migrate_database:
  cmd.wait:
  - name: {{ server.dir.base }}/bin/python {{ server.dir.base }}/bin/manage.py migrate --noinput
  - require:
    - file: django_conf_settings

{%- endif %}
