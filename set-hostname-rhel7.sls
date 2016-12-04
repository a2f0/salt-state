set-hostname-no-persist:
  cmd.run:
    - name: hostname {{ pillar['fqdn'] }}
