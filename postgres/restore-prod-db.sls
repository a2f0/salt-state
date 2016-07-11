#temporarily grant superuser to do the restore
devopsrockstars-dbaccess-temp-superuser:
  postgres_user.present:
    - name: {{ pillar['pguser'] }} 
    - login: True
    - superuser: True
    - password: {{ pillar['pgpass'] }}

stop-apache-to-try-and-kill-db-connection:
  cmd.run:
    - name: service httpd stop && sleep 10
    - stateful: False

devopsrockstars-drop-db:
  postgres_database.absent:
    - name: devopsrockstars

devopsrockstars-recreate-db:
  postgres_database.present:
    - name: devopsrockstars
    - owner: {{ pillar['pguser'] }}

restore-production-devopsrockstars-db:
  cmd.run:
    - name: pg_restore -h localhost -p 5432 -U {{ pillar['pguser'] }} -d devopsrockstars /mnt/devopsrockstars-web-backup/web-production-latest.psql
    - stateful: False

#shut it down afterwards
devopsrockstars-dbaccess-revoke-superuser:
  postgres_user.present:
    - name: {{ pillar['pguser'] }} 
    - login: True
    - superuser: False
    - password: {{ pillar['pgpass'] }}
