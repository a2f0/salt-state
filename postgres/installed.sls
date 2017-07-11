{% if grains['os'] == 'Amazon' %}

include:
  - postgres.pgpass

postgresql92-server:
  pkg.installed

#doesn't exist in amazonlinux docker image
#needed for rc file
/etc/sysconfig/network:
  file.managed:
     - user: root
     - group: root
     - mode: 644

make-postgres-data-dir:
  postgres_initdb.present:
    - name: '/var/lib/pgsql92/data'
    - auth: trust
    - user: postgres
    - password: {{ pillar['pgpass'] }}
    - encoding: UTF8
    - runas: postgres

postgresql92:
  service.running:
    - enable: True
    - reload: True

dbaccess-user:
  postgres_user.present:
    - name: {{ pillar['pguser'] }} 
    - login: True
    - password: {{ pillar['pgpass'] }}

allow_local_authentication-ipv4:
  file.replace:
    - name: /var/lib/pgsql92/data/pg_hba.conf
    - count: 1
    - pattern: ^host    all             all             127.0.0.1/32            ident
    - repl: host    all             all             127.0.0.1/32            password

allow_local_authentication-ipv6:
  file.replace:
    - name: /var/lib/pgsql92/data/pg_hba.conf
    - count: 1
    - pattern: ^host    all             all             ::1/128                 ident
    - repl: host    all             all             ::1/128                 password

listen-on-all-interfaces:
  file.replace:
    - name: /var/lib/pgsql92/data/postgresql.conf
    - count: 1
    - pattern: ^#listen_addresses = 'localhost'
    - repl: listen_addresses = '*'

postgresql-running:
  service.running:
    - name: postgresql92
    - watch:
      - file: /var/lib/pgsql92/data/pg_hba.conf
      - file: /var/lib/pgsql92/data/postgresql.conf

{% elif grains['os'] == 'MacOS' %}

postgresql:
  pkg.installed

start-server:
  cmd.run:
    - name: brew services start postgresql
    - unless: brew services list | grep started | grep postgresql -q 

{% endif %}

