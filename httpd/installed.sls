#include:
#  - httpd.name-based-virtual-hosting
#  - httpd.default-website

httpd:
  pkg.installed:
    - names:
      - httpd
      - mod_ssl