/etc/httpd/conf.d/{{ pillar['fqdn-top'] }}.conf:
  apache.configfile:
    - config:
      - VirtualHost:
          this: '*:80'
          ServerName:
            - {{ pillar['fqdn-top'] }}
          ErrorLog: logs/{{ pillar['fqdn-top'] }}
          CustomLog: logs/{{ pillar['fqdn-top'] }} combined
          DocumentRoot: /opt/code/dansullivan-top
          Directory:
            this: /opt/code/dansullivan-top
            Order:
              - allow,deny
            Allow from:
              - all
            Require:
              - all granted
            Satisfy:
              - Any
