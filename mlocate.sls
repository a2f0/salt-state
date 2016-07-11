mlocate:
  pkg.installed

updatemlocatedb:
  cmd.run:
    - name: updatedb
    - stateful: False
