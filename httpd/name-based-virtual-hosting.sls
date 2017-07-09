include:
  - httpd.default-website

/etc/httpd/conf.d/name-based-virtual-hosting-80.conf:
  apache.configfile:
    - config:
      - NameVirtualHost: '*:80'

/etc/httpd/conf.d/name-based-virtual-hosting-443.conf:
  apache.configfile:
    - config:
      - NameVirtualHost: '*:443'