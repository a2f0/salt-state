restore-certbot:
  cmd.run:
    - name: cd /opt && tar -zxvf /mnt/devopsrockstars-web-backup/certbot-{{ pillar['environment'] }}-latest.tar.gz

cd /opt && tar -czvf /mnt/devopsrockstars-web-backup/certbot-{{ pillar['environment'] }}-`date +\%m`.`date +\%d`.`date +\%y`.tar.gz certbot && rm -rf /mnt/devopsrockstars-web-backup/certbot-{{ pillar['environment'] }}-latest.tar.gz && ln -s /mnt/devopsrockstars-web-backup/certbot-{{ pillar['environment'] }}-`date +\%m`.`date +\%d`.`date +\%y`.tar.gz /mnt/devopsrockstars-web-backup/certbot-{{ pillar['environment'] }}-latest.tar.gz:
  cron.present:
    - user: root
    - minute: random
    - hour: 2
    - commented: False
