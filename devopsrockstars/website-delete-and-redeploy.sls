include:
  - httpd.dead
  - devopsrockstars.website

clean-existing-website:
   file.directory:
      - name: /opt/code/devopsrockstars.com          
      - clean: True
      - prereq_in:
        - service: httpd-dead-user-change
      - onchanges_in:
        - git: devopsrockstars-code