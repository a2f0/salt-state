base:
  '*':
    - baseline
  'devopsrockstars-prod':
    - web-frontend-packages
    - mlocate
    - s3fs.install-s3fs-rhel7
    - certbot-restore-and-schedule-backup
    - postgres.pgpass
    - postgres.postgres-server
    - postgres.restore-prod-db
    - postgres.backup-database-cron
    - web-frontend
    - deploy-code
    - passenger-amazon-linux
    - passenger-module
    - devopsrockstars-website
    - paperclip-restore-and-schedule-backup
    - solr.bootstrapsolr
    - set-hostname-rhel7
    - pagespeed
    - httpd.default-website
  'dansullivan':
    - s3fs.install-s3fs-rhel7
    - dansullivan.dokuwiki
    - dansullivan.vhost
    - httpd.redirect-80-to-443
    - httpd.default-website
    - dansullivan.certbot
  'os:MacOS':
    - match: grain
    - macos
