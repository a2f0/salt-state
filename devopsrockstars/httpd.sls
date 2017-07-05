include:
  - passenger.httpd-module

/etc/httpd/conf.d/{{ pillar['fqdn'] }}-ssl.conf:
  apache.configfile:
    - config:
      - VirtualHost:
          this: '*:443'
          SSLEngine: 'on'
          Header: set Access-Control-Allow-Origin "*"
          SSLCertificateFile: /opt/certbot/config/live/{{ pillar['fqdn2'] }}/cert.pem
          SSLCertificateKeyFile: /opt/certbot/config/live/{{ pillar['fqdn2'] }}/privkey.pem
          SSLCertificateChainFile: /opt/certbot/config/live/{{ pillar['fqdn2'] }}/fullchain.pem
          SSLProtocol: all -SSLv2
          SSLCipherSuite: ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW
          ServerName:
            - {{ pillar['fqdn'] }}
          ServerAlias:
            - {{ pillar['fqdn2'] }}
          ErrorLog: logs/{{ pillar['fqdn'] }}-ssl-error_log
          CustomLog: logs/{{ pillar['fqdn'] }}-ssl-access_log combined
          DocumentRoot: /opt/code/devopsrockstars.com/public
          PassengerRuby: /home/apache/.rbenv/versions/2.3.0/bin/ruby
          PassengerRoot: /home/apache/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/passenger-{{ pillar['passenger_version'] }}
          PassengerMinInstances: 3
          PassengerPreStart: https://{{ pillar['fqdn'] }}
          RailsEnv: {{ pillar['environment'] }}
          AddType:
            - image/svg+xml svg svgz
          AddEncoding:
            - gzip svgz
          Directory:
            this: /opt/code/devopsrockstars.com/public
            Order:
              - allow,deny
            Allow from:
              - all
            Require:
              - all granted
            Satisfy:
              - Any
          #/.well-known for certbot
          Location:
            this: /.well-known
            Order:
              - allow,deny
            Allow from:
              - all
      