#include:
#  - users

apache-user-present:
  user.present:
    - name: apache
    - home: /home/apache
    - prereq_in:
      - service: httpd-stopped-user-change
    #  - cmd: wait-for-passenger

httpd-running:
  service.running:
    - name: httpd
    - init_delay: 5
    - require:
      - user: apache
    - onchanges:
      - user: apache

httpd-stopped-user-change:
  service.dead:
    - name: httpd
    - prereq:
      - user: apache-user-present
    - sig: 'Passenger'
    - onchanges_in: 
      - cmd: wait-for-passenger

wait-for-passenger:
  cmd.run:
    - name: while pgrep -u apache > /dev/null; do sleep 1; done 
    - prereq:
      - user: apache
