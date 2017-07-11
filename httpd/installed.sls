#include:
#  - httpd.name-based-virtual-hosting
#  - httpd.default-website

{% if grains['os'] == 'Amazon' %}

httpd:
  pkg.installed:
    - names:
      - httpd
      - mod_ssl
      
{% endif %}

