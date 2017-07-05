include:
  - httpd.installed
  - users

httpd-running:
  service.running:
    - name: httpd
    - require:
      - user: apache
      - pkg: httpd
    - watch:
      - apache: /etc/httpd/conf.d/00-default.conf
      - apache: /etc/httpd/conf.d/name-based-virtual-hosting-80.conf
      - apache: /etc/httpd/conf.d/name-based-virtual-hosting-443.conf
      - file: /opt/code/devopsrockstars.com/config/application.yml

#httpd-dead-user-change:
#  service.dead:
#    - name: httpd
#    - prereq:
#      - user: apache
#    - sig: 'Passenger'
#    - onchanges_in:
#      - cmd: wait-for-passenger

#wait-for-passenger:
#  cmd.run:
#    - name: while pgrep -u apache > /dev/null; do sleep 1; done 
#    - prereq:
#      - user: apache
