include:
  - baseline
  - httpd.installed
  - git.installed
  - users
  - rbenv.installed
  - passenger.installed
  - devopsrockstars.figaro
  - nodejs.installed


/opt/code/devopsrockstars.com:
  file.directory:
    - user: apache
    - group: apache
    - dir_mode: 750
    - require:
      - file: /opt/code
      - user: apache

devopsrockstars-code:
  git.latest:
    - name: git@github.com:deepeeess/devopsrockstars-new.git
    - target: /opt/code/devopsrockstars.com
    - user: apache
    - require:
      - file: /opt/code/devopsrockstars.com
      - rbenv: ruby-2.3.0
      - pkg: git
      - ssh_known_hosts: github.com
    - onchanges_in:
      - cmd: bundle-install
      - cmd: restart-passenger-app
      - cmd: rake-assets-clobber
      - cmd: rake-assets-precompile

devopsrockstars-gemfile-deps:
  pkg.installed:
    - names:
      - postgresql92-devel
      - gcc-c++

bundle-install:
   cmd.run:
    - name: bundle install --without development test
    - runas: apache
    - cwd: /opt/code/devopsrockstars.com
    - require:
      - file: /opt/code/devopsrockstars.com
      - git: devopsrockstars-code
      - rbenv: ruby-2.3.0
      - pkg: devopsrockstars-gemfile-deps

rake-assets-clobber:
   cmd.run:
    - name: bundle exec rake assets:clobber
    - runas: apache
    - cwd: /opt/code/devopsrockstars.com
    - require:
      - file: /opt/code/devopsrockstars.com
      - git: devopsrockstars-code
      - rbenv: ruby-2.3.0
      - pkg: devopsrockstars-gemfile-deps
    - env:
      - RAILS_ENV: {{ pillar['environment'] }}

rake-assets-precompile:
   cmd.run:
    - name: bundle exec rake assets:precompile
    - runas: apache
    - cwd: /opt/code/devopsrockstars.com
    - require:
      - file: /opt/code/devopsrockstars.com
      - git: devopsrockstars-code
      - rbenv: ruby-2.3.0
      - pkg: devopsrockstars-gemfile-deps
    - env:
      - RAILS_ENV: {{ pillar['environment'] }}