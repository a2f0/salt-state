/bin/bash -l -c "pg_dump -Fc --no-owner -U {{ pillar['pguser'] }} -h localhost -p 5432 devopsrockstars > /mnt/devopsrockstars-web-backup/web-{{ pillar['environment'] }}-`date +\%m`.`date +\%d`.`date +\%y`.psql && rm -rf /mnt/devopsrockstars-web-backup/web-{{ pillar['environment'] }}-latest.psql && ln -s /mnt/devopsrockstars-web-backup/web-{{ pillar['environment'] }}-`date +\%m`.`date +\%d`.`date +\%y`.psql /mnt/devopsrockstars-web-backup/web-{{ pillar['environment'] }}-latest.psql":
  cron.present:
    - user: root
    - minute: random
    - minute: '*/5'
    - commented: False
