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
    - postgres.backup-database-cron
    - postgres.restore-prod-db
    - web-frontend
    - devopsrockstars-website
    - paperclip-restore-and-schedule-backup
    - solr.bootstrapsolr
    - set-hostname-rhel7
    - pagespeed
  'devopsrockstars-test':
    - web-frontend-packages
    - mlocate
    - s3fs.install-s3fs-rhel7
    - certbot-restore-and-schedule-backup
    - postgres.pgpass
    - postgres.postgres-server
    - postgres.backup-database-cron
    - postgres.restore-prod-db
    - web-frontend
    - devopsrockstars-website
    - paperclip-restore-and-schedule-backup
    - solr.bootstrapsolr
    - set-hostname-rhel7
    - pagespeed
  'dansullivan':
    - web-frontend-packages
    - s3fs.install-s3fs-rhel7
  'os:MacOS':
    - match: grain
    - macos

dev:
  '*':
    - baseline
  'os:MacOS':
    - match: grain
    - macos
