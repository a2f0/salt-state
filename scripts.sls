include:
  - git.github-known-host
  - baseline
  - users

/opt/code/scripts:
  file.directory:
    - user: apache
    - group: apache
    - dir_mode: 750
    - require:
      - file: /opt/code
      - user: apache

deploy-scripts:
  git.latest:
    - name: git@github.com:deepeeess/scripts.git
    - target: /opt/code/scripts
    - user: apache
    - require:
      - ssh_known_hosts: github.com