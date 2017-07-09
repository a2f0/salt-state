include:
  - httpd.dead
  - devopsrockstars.database

devopsrockstars-drop-db:
  postgres_database.absent:
    - name: {{ pillar['pgdatabase'] }} 
    - user: {{ pillar['pg_system_user'] }}
    - prereq_in:
      - service: httpd-dead-user-change
    - onchanges_in:
      - postgres_database: devopsrockstars-create-db