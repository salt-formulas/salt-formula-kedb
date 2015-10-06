{% from "kedb/map.jinja" import server with context %}

import os
import sys

sys.stdout = sys.stderr

import site

site.addsitedir('/srv/kedb/lib/python{{ server.python_version }}/site-packages')

import os
#os.environ['PYTHON_EGG_CACHE'] = '/www/lostquery.com/mod_wsgi/egg-cache'

sys.path.append('/srv/kedb/kedb')
sys.path.append('/srv/kedb/site')
os.environ['DJANGO_SETTINGS_MODULE'] = 'core.settings'

import django.core.handlers.wsgi

application = django.core.handlers.wsgi.WSGIHandler()
