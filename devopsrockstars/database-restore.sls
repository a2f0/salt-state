include:
  - aws.installed
  - users
  - postgres.installed

devopsrockstars-drop-db:
  postgres_database.absent:
    - name: {{ pillar['pgdatabase'] }} 
    - user: {{ pillar['pg_system_user'] }}

devopsrockstars-create-db:
  postgres_database.present:
    - name: {{ pillar['pgdatabase'] }}
    - owner: {{ pillar['pguser'] }}
    - user: {{ pillar['pg_system_user'] }}

#devopsrockstars-drop-db-1:
#  postgres_database.absent:
#    - name: {{ pillar['pgdatabase'] }} 
#    - prereq_in:
#      - service: httpd-dead-user-change
#    - onchanges_in:
#      - postgres_database: devopsrockstars-db-config

#devopsrockstars-db-config:
#  postgres_database.present:
#    - name: devopsrockstars
#    - owner: {{ pillar['pguser'] }}
#    - require:
#      - sls: postgres.installed
#      - postgres_user: devopsrockstars-dbaccess-temp-superuser
#      - postgres_user: devopsrockstars-postgres-user      
#    - onchanges_in:
#      - cmd: stage-db-from-s3

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
    - require:
      - postgres_user: devopsrockstars-dbaccess-temp-superuser

#stop-apache-to-try-and-kill-db-connection:
#  cmd.run:
#    - name: service httpd stop && sleep 10
#    - stateful: False

#devopsrockstars-recreate-db:
#  postgres_database.present:
#    - name: {{ pillar['pgdatabase'] }}
#    - owner: {{ pillar['pguser'] }}
#    - user: {{ pillar['pg_system_user'] }}

stage-db-from-s3:
  cmd.run:
    - name: bash -il -c 'stage-devopsrockstars-prod'
    - require:
      - pkg: aws-cli
      - user: root
    - onchanges_in:
      - cmd: restore-production-devopsrockstars-db

restore-production-devopsrockstars-db:
  cmd.run:
    - name: pg_restore -U postgres -d {{ pillar['pgdatabase'] }} /tmp/devopsrockstars-postgres-staged
    - stateful: False
    - runas: {{ pillar['pg_system_user'] }}
    - require:
      - postgres_database: devopsrockstars-create-db
    - onchanges_in:
      - cmd: devopsrockstars-dbaccess-revoke-superuser
      - postgres_user: devopsrockstars-dbaccess-revoke-superuser

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
