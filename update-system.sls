update the system:
  pkg.uptodate:
    - name: allthepkgz
    - refresh: True

httpd:
  service.running:
    - watch:
      - pkg: update the system
