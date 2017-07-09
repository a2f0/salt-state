include:
  - devopsrockstars.website

restart-passenger-app:  
  cmd.run:
    - name: passenger-config restart-app /opt/code/devopsrockstars.com
    - runas: apache
    - onlyif: passenger-status | grep -q /opt/code/devopsrockstars.com
    - onchanges:
      - git: devopsrockstars-code
      - file: /opt/code/devopsrockstars.com/config/application.yml
      - file: /opt/code/devopsrockstars.com/config/database.yml