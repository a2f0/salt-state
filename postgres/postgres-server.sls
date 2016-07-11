postgresql-server:
  pkg.installed

enablepostgresql-server:
  cmd.run:
    - name: chkconfig postgresql on
    - stateful: False

initializedbcluster:
  cmd.run:
    - name: postgresql-setup initdb || true
    - stateful: False

postgresql:
  service.running:
    - enable: True

#this is the user
devopsrockstars-dbaccess-user:
  postgres_user.present:
    - name: {{ pillar['pguser'] }} 
    - login: True
    - password: {{ pillar['pgpass'] }}

#this is the role
devopsrockstars-dbaccess-role:
  postgres_group.present:
    - name: devopsrockstars
    - login: True
    - password: {{ pillar['pgpass'] }}

devopsrockstars-db-config:
  postgres_database.present:
    - name: devopsrockstars
    - owner: {{ pillar['pguser'] }} 

allow_local_authentication-ipv4:
  file.replace:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - count: 1
    - pattern: ^host    all             all             127.0.0.1/32            ident
    - repl: host    all             all             127.0.0.1/32            password

allow_local_authentication-ipv6:
  file.replace:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - count: 1
    - pattern: ^host    all             all             ::1/128                 ident
    - repl: host    all             all             ::1/128                 password

listen-on-all-interfaces:
  file.replace:
    - name: /var/lib/pgsql/data/postgresql.conf
    - count: 1
    - pattern: ^#listen_addresses = 'localhost'
    - repl: listen_addresses = '*'

allow-inbound-tcpip-db:
  file.append:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - text: host    all             all             {{ pillar['vpn'] }}            password

bouncepostgresql-server:
  cmd.run:
    - name: service postgresql restart
    - stateful: False
