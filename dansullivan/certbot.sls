getcrt:
  cmd.run:
    - stateful: False
    - name: {{ pillar['certbot_path'] }} certonly -n --webroot -w /opt/code/dansullivan-website -d {{ pillar['fqdn'] }} --logs-dir=/opt/certbot/logs --config-dir=/opt/certbot/config --work-dir=/opt/certbot/work --email=webmaster@devopsrockstars.com --agree-tos --expand --hsts --post-hook 'apachectl restart' --debug

{{ pillar['certbot_path'] }} certonly -n --webroot -w /opt/code/devopsrockstars-website/public -d {{ pillar['fqdn'] }} --logs-dir=/opt/certbot/logs --config-dir=/opt/certbot/config --work-dir=/opt/certbot/work --email=webmaster@devopsrockstars.com --agree-tos --expand --hsts --post-hook 'apachectl restart' --debug:
  cron.present:
    - user: root
    - minute: random
    - hour: 2
    - commented: False
