#customuptime:
#  cmd.run:
#    - name: /usr/bin/uptime
#    - cwd: /
#    - stateful: False

#openssl:
#  pkg.installed

#moreutils:
#  pkg.installed

macos-packages:
  pkg.installed:
  - pkgs:
    - openssl
    - moreutils
    - blackbox
