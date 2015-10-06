{%- set server = pillar.kedb.server %}
{%- if server.enabled %}

include:
- git
- python

kedb_packages:
  pkg.installed:
  - names:
    - python-pip
    - python-virtualenv
    - python-imaging
    - python-docutils
    - python-simplejson
    {%- if grains.os_family == 'Debian' %}
    - python-tz
    - python-memcache
    - build-essential
    - libssl-dev
    - libffi-dev
    - python-dev
    {%- endif %}
    {%- if grains.os_family == 'RedHat' %}
    - python-memcached
    - gcc
    - libffi-devel
    - python-devel 
    - openssl-devel
    - MySQL-python
    {%- endif %}
    - gettext
  - require:
    - pkg: python_packages

/srv/kedb:
  virtualenv.manage:
  - system_site_packages: True
  - requirements: salt://kedb/conf/requirements.txt
  - require:
    - pkg: kedb_packages

kedb_user:
  user.present:
  - name: kedb
  - system: True
  - home: /srv/kedb
  - require:
    - virtualenv: /srv/kedb

{{ server.source.address }}:
  git.latest:
  - target: /srv/kedb/kedb
  - rev: {{ server.source.rev }}
  - require:
    - virtualenv: /srv/kedb
    - pkg: git_packages

/srv/kedb/site/core/wsgi.py:
  file:
  - managed
  - source: salt://kedb/conf/wsgi.py
  - mode: 755
  - template: jinja
  - require:
    - file: /srv/kedb/site/core

/srv/kedb/bin/gunicorn_start:
  file.managed:
  - source: salt://kedb/conf/gunicorn_start
  - mode: 700
  - user: kedb
  - group: kedb
  - template: jinja
  - require:
    - virtualenv: /srv/kedb

kedb_dirs:
  file.directory:
  - names:
    - /srv/kedb/site/core
    - /srv/kedb/static
    - /srv/kedb/logs
  - user: root
  - group: root
  - mode: 755
  - makedirs: true
  - require:
    - virtualenv: /srv/kedb

/srv/kedb/media:
  file:
  - directory
  - user: kedb
  - group: kedb
  - mode: 755
  - makedirs: true
  - require:
    - virtualenv: /srv/kedb

/srv/kedb/site/core/settings.py:
  file.managed:
  - user: root
  - group: root
  - source: salt://kedb/files/settings.py
  - template: jinja
  - mode: 644
  - require:
    - file: kedb_dirs

/srv/kedb/site/core/__init__.py:
  file.managed:
  - user: root
  - group: root
  - template: jinja
  - mode: 644
  - require:
    - file: kedb_dirs

/srv/kedb/site/manage.py:
  file.managed:
  - user: root
  - group: root
  - source: salt://kedb/conf/manage.py
  - template: jinja
  - mode: 755
  - require:
    - file: kedb_dirs

sync_database_kedb:
  cmd.run:
  - name: python manage.py syncdb --noinput
  - cwd: /srv/kedb/site
  - require:
    - file: /srv/kedb/site/manage.py

migrate_database_kedb:
  cmd.run:
  - name: python manage.py migrate --noinput
  - cwd: /srv/kedb/site
  - require:
    - cmd: sync_database_kedb

collect_static_kedb:
  cmd.run:
  - name: python manage.py collectstatic --noinput
  - cwd: /srv/kedb/site
  - require:
    - cmd: sync_database_kedb

{%- endif %}