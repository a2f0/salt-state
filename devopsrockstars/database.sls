include:
  - aws.installed
  - users
  - postgres.installed
  - scripts

#temporarily grant superuser to do the restore
#needed for MacOs
devopsrockstars-dbaccess-temp-superuser:
  postgres_user.present:
    - name: {{ pillar['pguser'] }} 
    - login: True
    - superuser: True
    - user: {{ pillar['pg_system_user'] }}
    - password: {{ pillar['pgpass'] }}
    - prereq:
      - postgres_database: devopsrockstars-create-db

devopsrockstars-create-db:
  postgres_database.present:
    - name: {{ pillar['pgdatabase'] }}
    - owner: {{ pillar['pguser'] }}
    - user: {{ pillar['pg_system_user'] }}
    - prereq_in:
      - devopsrockstars-dbaccess-temp-superuser
    - onchanges_in:
      - cmd: stage-db-from-s3

#for MacOs brew installations of PostgreSQL server.
devopsrockstars-postgres-user:
  postgres_user.present:
    - name: postgres
    - login: true
    - superuser: true
    - user: {{ pillar['pg_system_user'] }}
    - password: {{ pillar['pgpass'] }}

stage-db-from-s3:
  cmd.run:
    - name: /opt/code/scripts/stage-mostrecent-from-s3.sh devopsrockstars-web-backup devopsrockstars-postgres
    - require:
      - sls: aws.installed
      - git: deploy-scripts
      - sls: users
    - onchanges_in:
      - cmd: restore-production-devopsrockstars-db
    - timeout: 60
    - user: {{ pillar['whoami'] }}

restore-production-devopsrockstars-db:
  cmd.run:
    - name: pg_restore -U postgres -d {{ pillar['pgdatabase'] }} /tmp/devopsrockstars-postgres-staged
    - stateful: False
    - runas: {{ pillar['pg_system_user'] }}
    - require:
      - postgres_database: devopsrockstars-create-db
    - timeout: 60

#revoke it afterwards
devopsrockstars-dbaccess-revoke-superuser:
  postgres_user.present:
    - name: {{ pillar['pguser'] }} 
    - login: True
    - superuser: False
    - password: {{ pillar['pgpass'] }}
    - user: {{ pillar['pg_system_user'] }}
    - onchanges:
      - cmd: restore-production-devopsrockstars-db