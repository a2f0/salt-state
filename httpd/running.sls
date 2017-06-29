include:
  - httpd.installed
  - users

#apache-user-present:
#  user.present:
#    - name: apache
#    - home: /home/apache
#    - prereq_in:
#      - service: httpd-stopped-user-change
#    #  - cmd: wait-for-passenger

httpd-running:
  service.running:
    - name: httpd
    - require:
      - user: apache
#    - onchanges:
#      - user: apache

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
