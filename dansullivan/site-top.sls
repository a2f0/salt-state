/opt/code/dansullivan-top:
  file.directory:
    - user: apache
    - group: apache
    - makedirs: True

dansullivan-io-website:
  git.latest:
    - name: https://github.com/deepeeess/dansullivan.io.git
    - target: /opt/code/dansullivan-top
    - user: apache
    - force_clone: True
    - force_reset: True
    - force_checkout: True
