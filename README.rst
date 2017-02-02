
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

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-kedb/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-kedb

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
