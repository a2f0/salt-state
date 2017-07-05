include:
  - httpd.name-based-virtual-hosting
  - httpd.default-website
  - httpd.running
  - users

httpd:
  pkg.installed:
    - names:
      - httpd
      - mod_ssl
    - require:
      - user: apache