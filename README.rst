
====================
Known Error Database
====================

Sample pillar
=============

    kedb:
      server:
        enabled: true
        workers: 3
        secret_key: secret_token
        bind:
          address: 0.0.0.0
          port: 9753
          protocol: tcp
        source:
          type: 'git'
          address: 'git@repo1.robotice.cz:django/django-kedb.git'
          rev: 'master'
        cache:
          engine: 'memcached'
          host: '127.0.0.1'
          prefix: 'CACHE_KEDB'
        database:
          engine: 'postgresql'
          host: '127.0.0.1'
          name: 'django_kedb'
          password: 'db-pwd'
          user: 'django_kedb'
        mail:
          host: 'mail.domain.com'
          password: 'mail-pwd'
          user: 'mail-user'
        logger_handler:
          engine: raven
          dsn: http://public:private@host/project

Read more
=========

* http://docs.gunicorn.org/en/latest/configure.html
