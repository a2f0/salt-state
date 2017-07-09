include:
  - aws.installed
  - scripts

/opt/code/devopsrockstars.com/public/paperclip:
  file.directory:
    - user: apache
    - group: apache
    - dir_mode: 755
    - require:
      - git: devopsrockstars-code

restore-paperclip:
  cmd.run:
    - name: /opt/code/scripts/restore-from-s3.sh /opt/code/devopsrockstars.com/public devopsrockstars-web-backup devopsrockstars-paperclip-production 4
    - user: apache
    - onlyif: test -z "$(ls -A /opt/code/devopsrockstars.com/public/paperclip/*)"
    - require:
      - git: deploy-scripts
      - pkg: aws-cli
      - file: /opt/code/devopsrockstars.com/public/paperclip
    - timeout: 60