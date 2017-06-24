include:
  - httpd.httpd-running

update the system:
  pkg.uptodate:
    - name: allthepkgz
    - refresh: True
