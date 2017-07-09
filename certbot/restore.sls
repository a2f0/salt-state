include:
  - baseline
  - users
  - scripts
  - certbot.installed
  - aws.installed
  
/opt/certbot:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750
    - require:
      - file: /opt

restore-certbot:
  cmd.run:
    - name: bash -il -c 'restore-certbot'
    - onlyif: test -z "$(ls -A /opt/certbot/*)"
    - shell: /bin/bash
    - require:
      - sls: aws.installed
      - user: root
      - file: /opt/certbot
      - git: deploy-scripts
    - timeout: 60