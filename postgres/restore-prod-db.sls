#temporarily grant superuser to do the restore
devopsrockstars-dbaccess-temp-superuser:
  postgres_user.present:
    - name: {{ pillar['pguser'] }} 
    - login: True
    - superuser: True
    - user: {{ pillar['pg_system_user'] }}
    - password: {{ pillar['pgpass'] }}

#add the postgres user for MacOs brew installations of PostgreSQL server.
devopsrockstars-postgres-user:
  postgres_user.present:
    - name: postgres
    - login: False 
    - superuser: True
    - user: {{ pillar['pg_system_user'] }}
    - password: {{ pillar['pgpass'] }}

stop-apache-to-try-and-kill-db-connection:
  cmd.run:
    - name: service httpd stop && sleep 10
    - stateful: False

devopsrockstars-drop-db:
  postgres_database.absent:
    - name: devopsrockstars
    - user: {{ pillar['pg_system_user'] }}

devopsrockstars-recreate-db:
  postgres_database.present:
    - name: devopsrockstars
    - owner: {{ pillar['pguser'] }}
    - user: {{ pillar['pg_system_user'] }}

restore-production-devopsrockstars-db:
  cmd.run:
    - name: ls -l /mnt/devopsrockstars-web-backup/web-production-latest.psql && pg_restore -h localhost -p 5432 -U {{ pillar['pguser'] }} -d devopsrockstars /mnt/devopsrockstars-web-backup/web-production-latest.psql
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
