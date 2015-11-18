{%- from "kedb/map.jinja" import server with context %}

include:
- git
- python

kedb_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

kedb_user:
  user.present:
  - name: {{ server.user }}
  - system: True
  - home: {{ server.dir.home }}

kedb_dirs:
  file.directory:
  - names:
    - /etc/kedb
    - {{ server.dir.base }}
    - /var/lib/kedb/static
    - /var/lib/kedb/media
    - /usr/lib/kedb/bin
    - /var/log/kedb
  - user: {{ server.user }}
  - group: {{ server.group }}
  - mode: 755
  - makedirs: true
  - require:
    - user: kedb_user

kedb_log:
  file.managed:
    - name: /var/log/kedb/django.log
    - user: {{ server.user }}
    - group: {{ server.group }}
    - replace: False
    - require:
      - file: kedb_dirs

kedb_git_setup:
  git.latest:
  - name: {{ server.source.address }}
  - target: {{ server.dir.workspace }}
  - rev: {{ server.source.get('revision', server.source.get('rev', 'master')) }}
  - require:
    - pkg: git_packages
    - user: kedb_user
  - watch_in:
    - cmd: kedb_install

kedb_python_virtualenv:
  virtualenv.manage:
  - name: {{ server.dir.base }}
  - requirements: {{ server.dir.workspace }}/requirements.txt
  - require:
    - pkg: kedb_packages
    - git: kedb_git_setup

kedb_install:
  cmd.wait:
    - name: {{ server.dir.base }}/bin/python setup.py install
    - cwd: {{ server.dir.workspace }}
    - require:
      - virtualenv: kedb_python_virtualenv
      - file: kedb_log
    - watch_in:
      - cmd: django_migrate_database
      - cmd: django_collectstatic
    - require_in:
      - file: django_conf_settings

kedb_bin_python:
  file.symlink:
    - name: /usr/lib/kedb/bin/python
    - target: {{ server.dir.base }}/bin/python

kedb_bin_manage:
  file.symlink:
    - name: {{ server.dir.base }}/bin/manage.py
    - target: {{ server.dir.workspace }}/bin/manage.py

kedb_bin_gunicorn:
  file.symlink:
    - name: {{ server.dir.base }}/bin/gunicorn_start.sh
    - target: {{ server.dir.workspace }}/bin/gunicorn_start.sh

django_collectstatic:
  cmd.wait:
  - name: {{ server.dir.base }}/bin/python {{ server.dir.base }}/bin/manage.py collectstatic --noinput
  - require:
    - file: django_conf_settings

django_conf_gunicorn:
  file.managed:
  - name: /etc/kedb/gunicorn
  - user: root
  - group: {{ server.group }}
  - source: salt://kedb/files/gunicorn
  - template: jinja
  - mode: 640
  - require:
    - file: kedb_dirs
