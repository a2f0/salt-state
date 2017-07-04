include:
  - httpd.name-based-virtual-hosting
  - httpd.default-website
  - httpd.running
  - users

httpd:
  pkg.installed:
    - require:
      - user: apache