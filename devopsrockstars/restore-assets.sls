include:
  - aws.installed

/opt/code/devopsrockstars.com/public/paperclip:
  file.directory:
    - user: apache
    - group: apache
    - dir_mode: 755
    - require:
      - git: devopsrockstars-code

restore-paperclip:
  cmd.run:
    - name: bash -il -c 'restore-devopsrockstars-paperclip'
    - onlyif: test -z "$(ls -A /opt/code/devopsrockstars.com/public/paperclip/*)"
    - require:
      - pkg: aws-cli
      - file: /opt/code/devopsrockstars.com/public/paperclip