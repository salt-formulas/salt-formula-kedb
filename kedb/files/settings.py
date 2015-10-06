# -*- coding: utf-8 -*-
{%- set app = pillar.kedb.server %}

from os.path import join, dirname, abspath, normpath

DATABASES = {
    'default': {
        {%- if app.database.engine == 'mysql' %}
        'ENGINE': 'django.db.backends.mysql',
        'PORT': '3306',
        'OPTIONS': {'init_command': 'SET storage_engine=INNODB,character_set_connection=utf8,collation_connection=utf8_unicode_ci', },
        {% else %}
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'PORT': '5432',
        {%- endif %}
        'HOST': '{{ app.database.host }}',
        'NAME': '{{ app.database.name }}',
        'PASSWORD': '{{ app.database.password }}',
        'USER': '{{ app.database.user }}'
    }
}

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '{{ app.cache.host }}:11211',
        'TIMEOUT': 120,
        'KEY_PREFIX': '{{ app.cache.prefix }}'
    }
}

EMAIL_HOST = '{{ app.mail.host }}',
EMAIL_HOST_USER = '{{ app.mail.user }}',
EMAIL_HOST_PASSWORD = '{{ app.mail.password }}'

{%- if pillar.linux is defined %}
TIME_ZONE = '{{ pillar.linux.system.timezone }}'
{%- else %}
TIME_ZONE = '{{ pillar.system.timezone }}'
{%- endif %}

SECRET_KEY = '{{ app.secret_key }}'

{%- if app.logger_handler is defined %}
LOCAL_INSTALLED_APPS = (
    'raven.contrib.django.raven_compat',
)
{%- endif %}

RAVEN_CONFIG = {
{% if app.logger_handler is defined %}
    'dsn': '{{ app.logger_handler.dsn }}',
{% endif %}
}
