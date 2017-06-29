include:
  - users
  - update-system

httpd:
  service.running:
    - watch:
      - pkg: update the system
