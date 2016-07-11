customuptime:
  cmd.run:
    - name: /usr/bin/uptime
    - cwd: /
    - stateful: False

#verifysudoworks:
#  cmd.run:
#    - name: sudo /usr/bin/uptime
#    - cwd: /
#    - stateful: False
