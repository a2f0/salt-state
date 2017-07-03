include:
  - git.github-known-host
  - baseline
  - users

/opt/code/scripts:
  file.directory:
    - user: dps
    - group: dps
    - dir_mode: 755
    - require:
      - file: /opt/code
      - user: dps

deploy-scripts:
  git.latest:
    - name: https://github.com/deepeeess/scripts.git
    - target: /opt/code/scripts
    - user: dps
    - require:
      - user: dps