/etc/httpd/conf.d/passenger-module.conf:
  apache.configfile:
    - config:
      - LoadModule: 'passenger_module /home/apache/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/passenger-{{ pillar['passenger_version'] }}/buildout/apache2/mod_passenger.so'