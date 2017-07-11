include:
  - aws.installed
  - scripts

{{ pillar['devopsrockstars_code_path'] }}/public/paperclip:
  file.directory:
    - user: {{ pillar['whoami'] }}
    - dir_mode: 755
    - makedirs: True

restore-paperclip:
  cmd.run:
    - name: /opt/code/scripts/restore-from-s3.sh {{ pillar['devopsrockstars_code_path'] }}/public devopsrockstars-web-backup devopsrockstars-paperclip-production 4
    - user: {{ pillar['whoami'] }}
    - onlyif: test -z "$(ls -A {{ pillar['devopsrockstars_code_path'] }}/public/paperclip/*)"
    - require:
      - git: deploy-scripts
      - sls: aws.installed
      - file: {{ pillar['devopsrockstars_code_path'] }}/public/paperclip
    - timeout: 60