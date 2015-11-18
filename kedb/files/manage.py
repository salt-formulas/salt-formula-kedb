#!/usr/bin/env python

{ % from "kedb/map.jinja" import server with context % }

import sys
import os
from os.path import join, dirname, abspath, normpath

path = '/srv/kedb'
sys.path.append(
    join(path, 'lib', 'python{{ server.python_version }}', 'site-packages'))
sys.path.append(join(path, 'kedb'))
sys.path.append(join(path, 'site'))

#from django.core.management import execute_manager

# try:
#     from core import settings # Assumed to be in the project directory.
# except ImportError:
#    import sys
#    sys.stderr.write("Error: Can't find the file 'settings.py' in the directory containing %r. It appears you've customized things.\nYou'll have to run django-admin.py, passing it your settings module.\n(If the file settings.py does indeed exist, it's causing an ImportError somehow.)\n" % __file__)
#    sys.exit(1)

if __name__ == "__main__":
    #    execute_manager(settings)

    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
