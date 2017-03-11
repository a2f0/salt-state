/etc/httpd/conf.d/{{ pillar['fqdn'] }}-passenger.conf:
  apache.configfile:
    - config:
      - LoadModule: 'passenger_module /usr/local/rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/passenger-5.1.2/buildout/apache2/mod_passenger.so'

