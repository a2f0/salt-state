php:
  pkg.installed

/mnt/{{ pillar['bucketname'] }}:
  file.directory:
    - user: root
    - group: root
    - makedirs: True

/opt/code/dansullivan-website:
  file.directory:
    - user: apache
    - group: apache
    - makedirs: True

unpack-website-backup:
  cmd.run:
    #- name: tar -zxvf /mnt/dansullivan-io-backup/dansullivan.io-mostrecent.tar.gz --strip-components=2 -C /opt/code/dansullivan-website
    - name: tar -zxvf /mnt/dansullivan-io-backup/dokuwiki-latest.tar.gz --strip-components=1 -C /opt/code/dansullivan-website

fix-ownership:
  cmd.run:
    - name: chown -R apache:apache /opt/code/dansullivan-website/

#selinux configuration
#sudo chcon -Rv --type=httpd_sys_rw_content_t /var/www/html/wiki/conf
#sudo chcon -Rv --type=httpd_sys_rw_content_t /var/www/html/wiki/data
#sudo semanage fcontext -a -t httpd_sys_rw_content_t /var/www/html/wiki/conf
#sudo semanage fcontext -a -t httpd_sys_rw_content_t /var/www/html/wiki/data
#sudo restorecon -v /var/www/html/wiki/conf
#sudo restorecon -v /var/www/html/wiki/data

cd /opt/code/dansullivan-website && tar -czvf /mnt/{{ pillar['bucketname'] }}/dokuwiki-`date +\%m`.`date +\%d`.`date +\%y`.tar.gz html && rm -rf /mnt/{{ pillar['bucketname'] }}/dokuwiki-latest.tar.gz && ln -s /mnt/{{ pillar['bucketname'] }}/dokuwiki-`date +\%m`.`date +\%d`.`date +\%y`.tar.gz /mnt/{{ pillar['bucketname'] }}/dokuwiki-latest.tar.gz:
  cron.present:
    - user: root
    - minute: random
    - hour: 2
    - commented: False

#certbot certonly -n --webroot -w /var/www/html -d {{ pillar['fqdn'] }} --logs-dir=/opt/certbot/logs --config-dir=/opt/certbot/config --work-dir=/opt/certbot/work --email=dan@dansullivan.io --agree-tos --expand:
#  cron.present:
#    - user: root
#    - minute: random
#    - hour: 2
#    - commented: False
