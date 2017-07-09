/etc/httpd/conf.d/passenger-defaultruby.conf:
  apache.configfile:
    - config:
      - PassengerDefaultRuby: /home/apache/.rbenv/versions/2.3.0/bin/ruby
