include:
  - users

httpd-dead-user-change:
  service.dead:
    - name: httpd
    - prereq:
      - user: apache
    - sig: 'Passenger'
    - onchanges_in:
      - cmd: wait-for-passenger

wait-for-passenger:
  cmd.run:
    - name: while pgrep -u apache > /dev/null; do sleep 1; done
    - prereq:
      - user: apache
