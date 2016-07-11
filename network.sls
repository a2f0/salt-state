#system:
#  network.system:
#    - enabled: True
#    - hostname: {{ pillar['fqdn'] }}

#sethostnamerhel7:
#  cmd.run:
#    - name: hostnamectl set-hostname {{ pillar['fqdn'] }}
#   - stateful: False
