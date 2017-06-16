#ordering matters, which is why the 00 is first.
/etc/httpd/conf.d/00-default-custom.conf:
  apache.configfile:
    - config:
      - VirtualHost:
          this: '_default_:80'
          DocumentRoot: /var/www/html
