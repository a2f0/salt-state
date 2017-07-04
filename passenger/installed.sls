include:
  - rbenv.installed

passenger-deps:
  pkg.installed:
    - names:
      - httpd-devel
      - libcurl-devel
      - gcc-c++

passenger:
  gem.installed:
    - user: apache
    - ruby: 2.3.0
    - version: {{ pillar['passenger_version'] }}
    - require:
      - rbenv: ruby-2.3.0
      - pkg: passenger-deps

install-passenger-module:
  cmd.run:
    - name: passenger-install-apache2-module --auto
    - runas: apache
    - require:
      - rbenv: ruby-2.3.0
      - gem: passenger
    - unless: test -r /home/apache/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/passenger-{{ pillar['passenger_version'] }}/buildout/apache2/mod_passenger.so