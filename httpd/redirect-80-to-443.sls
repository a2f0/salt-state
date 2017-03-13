/etc/httpd/conf.d/{{ pillar['fqdn'] }}-redirect.conf:
  apache.configfile:
    - config:
      - VirtualHost:
          this: '*:80'
          ServerName:
            - {{ pillar['fqdn'] }}
          Redirect: / https://{{ pillar['fqdn'] }}
          ErrorLog: logs/{{ pillar['fqdn'] }}-redirect-error_log
          CustomLog: logs/{{ pillar['fqdn'] }}-redirect-access_log combined
