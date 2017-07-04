include:
  - httpd.default-website

/etc/httpd/conf.d/name-based-virtual-hosting-80.conf:
  apache.configfile:
    - config:
      - NameVirtualHost: '*:80'
    - require:
      - apache: /etc/httpd/conf.d/00-default.conf

/etc/httpd/conf.d/name-based-virtual-hosting-443.conf:
  apache.configfile:
    - config:
      - NameVirtualHost: '*:443'
    - require:
      - apache: /etc/httpd/conf.d/00-default.conf