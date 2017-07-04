include:
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

source-aliases-profile:
  file.append:
    - name: /etc/profile
    - text: source /opt/code/scripts/aliases

deploy-scripts:
  git.latest:
    - name: https://github.com/deepeeess/scripts.git
    - target: /opt/code/scripts
    - user: dps
    - require:
      - user: dps
      - file: /opt/code/scripts
      - file: source-aliases-profile