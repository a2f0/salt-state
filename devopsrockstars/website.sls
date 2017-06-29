include:
  - baseline
  - httpd.installed
  - git.installed
  - users
  - rbenv.installed

github.com:
  ssh_known_hosts:
    - present
    - user: apache
    - enc: rsa
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48

/opt/code/devopsrocktars.com:
  file.directory:
    - user: apache
    - group: apache
    - dir_mode: 750
    - require:
      - file: /opt/code

devopsrockstars-code:
  git.latest:
    - name: git@github.com:deepeeess/devopsrockstars-new.git
    - target: /opt/code/devopsrocktars.com
    - user: apache
    - require:
      - file: /opt/code/devopsrocktars.com
      - rbenv: ruby-2.3.0
      - pkg: git
      - ssh_known_hosts: github.com
