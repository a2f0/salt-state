include:
  - baseline
  - httpd.installed
  - git.installed
  - users
  - rbenv.installed
  - passenger.installed
  - git.github-known-host

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
    - onchanges_in:
      - cmd: bundle-install

devopsrockstars-gemfile-deps:
  pkg.installed:
    - names:
      - postgresql92-devel
      - gcc-c++

bundle-install:
   cmd.run:
    - name: bundle install --without development test
    - runas: apache
    - cwd: /opt/code/devopsrocktars.com
    - require:
      - file: /opt/code/devopsrocktars.com
      - git: devopsrockstars-code
      - rbenv: ruby-2.3.0
      - pkg: devopsrockstars-gemfile-deps
    - onchanges:
      - git: devopsrockstars-code