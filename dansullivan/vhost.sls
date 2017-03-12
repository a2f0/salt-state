/etc/httpd/conf.d/{{ pillar['fqdn'] }}-ssl.conf:
  apache.configfile:
    - config:
      - VirtualHost:
          this: '*:443'
          SSLEngine: 'on'
          SSLCertificateFile: /opt/certbot/config/live/{{ pillar['fqdn'] }}/cert.pem
          SSLCertificateKeyFile: /opt/certbot/config/live/{{ pillar['fqdn'] }}/privkey.pem
          SSLCertificateChainFile: /opt/certbot/config/live/{{ pillar['fqdn'] }}/fullchain.pem
          SSLProtocol: all -SSLv2
          SSLCipherSuite: ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW
          ServerName:
            - {{ pillar['fqdn'] }}
          ErrorLog: logs/{{ pillar['fqdn'] }}-ssl-error_log
          CustomLog: logs/{{ pillar['fqdn'] }}-ssl-access_log combined
          DocumentRoot: /opt/code/dansullivan-website
          Directory:
            this: /opt/code/dansullivan-website
            Order:
              - allow,deny
            Allow from:
              - all
            Require:
              - all granted
            Satisfy:
              - Any



