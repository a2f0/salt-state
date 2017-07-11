include:
  - baseline
  - users

/opt/code/scripts:
  file.directory:
    - user: {{ pillar['whoami'] }}
    - dir_mode: 755
    - require: 
      - file: /opt/code
      - sls: users

source-aliases-profile:
  file.append:
    - name: /etc/profile
    - text: source /opt/code/scripts/aliases

deploy-scripts:
  git.latest:
    - name: https://github.com/deepeeess/scripts.git
    - target: /opt/code/scripts
    - user: {{ pillar['whoami'] }}
    - require:
      - sls: users
      - file: /opt/code/scripts
      - file: source-aliases-profile