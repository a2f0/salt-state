#temporarily grant superuser to do the restore
devopsrockstars-dbaccess-temp-superuser:
  postgres_user.present:
    - name: {{ pillar['pguser'] }} 
    - login: True
    - superuser: True
    - user: {{ pillar['pg_system_user'] }}
    - password: {{ pillar['pgpass'] }}

#make sure the postgres user for MacOs brew installations of PostgreSQL server.
devopsrockstars-postgres-user:
  postgres_user.present:
    - name: postgres
    - login: true
    - superuser: true
    - user: {{ pillar['pg_system_user'] }}
    - password: {{ pillar['pgpass'] }}

#stop-apache-to-try-and-kill-db-connection:
#  cmd.run:
#    - name: service httpd stop && sleep 10
#    - stateful: False

stop-httpd-for-restore:
  service.dead:
    - name: httpd

devopsrockstars-drop-db:
  postgres_database.absent:
    - name: {{ pillar['pgdatabase'] }} 
    - user: {{ pillar['pg_system_user'] }}

devopsrockstars-recreate-db:
  postgres_database.present:
    - name: {{ pillar['pgdatabase'] }}
    - owner: {{ pillar['pguser'] }}
    - user: {{ pillar['pg_system_user'] }}

restore-production-devopsrockstars-db:
  cmd.run:
    - name: pg_restore -h localhost -p 5432 -U {{ pillar['pguser'] }} -d {{ pillar['pgdatabase'] }} /mnt/devopsrockstars-web-backup/web-production-latest.psql
    - stateful: False
    - runas: {{ pillar['pg_system_user'] }}

#revoke it afterwards
devopsrockstars-dbaccess-revoke-superuser:
  postgres_user.present:
    - name: {{ pillar['pguser'] }} 
    - login: True
    - superuser: False
    - password: {{ pillar['pgpass'] }}
    - user: {{ pillar['pg_system_user'] }}

#start-httpd-after-restore:
#  service.running:
#    - name: httpd
