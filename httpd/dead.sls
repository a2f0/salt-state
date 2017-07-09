httpd-dead-user-change:
  service.dead:
    - name: httpd
#   - prereq:
#      - file: clean-existing-website
#      - user: apache
#    - sig: 'Passenger'
    - onchanges_in:
      - cmd: wait-for-passenger

wait-for-passenger:
  cmd.run:
    - name: while pgrep -u apache > /dev/null; do sleep 1; done
    - prereq:
      - user: apache
