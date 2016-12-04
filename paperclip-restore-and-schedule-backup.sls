restore-paperclip:
  cmd.run:
    - name: cd /opt/code/devopsrockstars-website/public && tar -zxvf /mnt/devopsrockstars-web-backup/paperclip-production-latest.tar.gz

backup-paperclip:
  cmd.run:
    - name: cd /opt/code/devopsrockstars-website/public/ && tar -czvf /mnt/devopsrockstars-web-backup/paperclip-{{ pillar['environment'] }}-`date +%m`.`date +%d`.`date +%y`.tar.gz paperclip && rm -rf /mnt/devopsrockstars-web-backup/paperclip-{{ pillar['environment'] }}-`date +%m`.`date +%d`.`date +%y`.tar.gz /mnt/devopsrockstars-web-backup/paperclip-{{ pillar['environment'] }}-latest.tar.gz && ln -s /mnt/devopsrockstars-web-backup/paperclip-{{ pillar['environment'] }}-`date +%m`.`date +%d`.`date +%y`.tar.gz /mnt/devopsrockstars-web-backup/paperclip-{{ pillar['environment'] }}-latest.tar.gz

cd /opt/code/devopsrockstars-website/public/ && tar -czvf /mnt/devopsrockstars-web-backup/paperclip-{{ pillar['environment'] }}-`date +\%m`.`date +\%d`.`date +\%y`.tar.gz paperclip && rm -rf /mnt/devopsrockstars-web-backup/paperclip-{{ pillar['environment'] }}-latest.tar.gz && ln -s /mnt/devopsrockstars-web-backup/paperclip-{{ pillar['environment'] }}-`date +\%m`.`date +\%d`.`date +\%y`.tar.gz /mnt/devopsrockstars-web-backup/paperclip-{{ pillar['environment'] }}-latest.tar.gz:
  cron.present:
    - user: root
    - minute: '*/5'
    - commented: False
