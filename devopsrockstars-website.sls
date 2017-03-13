#clearoldcode:
#  cmd.run:
#    - name: rm -rf /opt/code/devopsrockstars-website

#/opt/code/devopsrockstars-website:
#  file.recurse:
#    - clean: True
#    - source: {{ pillar['sitesourcepath'] }}
#    - include_empty: True
#    - user: apache
#    - group: apache
#    - exclude_pat: .git/*
#    #- exclude_pat: (.git/*)
#"*.git*" appears to work.

#this can probably be removed completely.
#/etc/httpd/conf.d/{{ pillar['fqdn'] }}.conf:
#  apache.configfile:
#    - config:
#      - VirtualHost:
#          this: '*:80'
#          ServerName:
#            - devopsrockstars.com
#          ServerAlias:
#            - {{ pillar['fqdn'] }} 
#          ErrorLog: logs/{{ pillar['fqdn'] }}-error_log
#          CustomLog: logs/{{ pillar['fqdn'] }}-access_log combined
#          DocumentRoot: /opt/code/devopsrockstars-website/public
#          #PassengerRuby: /usr/bin/ruby
#          #PassengerMinInstances: 3
#          #PassengerPreStart: http://{{ pillar['fqdn'] }}
#          #RailsEnv: development
#          #AddType:
#          #  - image/svg+xml svg svgz
#          #AddEncoding:
#          #  - gzip svgz
#          Directory:
#            this: /opt/code/devopsrockstars-website/public
#            Allow from:
#              - all
#            Options: 
#              - -MultiViews
#            Require:
#              - all granted
#            #Order: Deny,Allow
#            #Deny from: all
#            #Allow from:
#            #  - 127.0.0.1
#            #  - 192.168.100.0/24
#            #Options:
#            #  - +Indexes
#            #  - FollowSymlinks
#            #AllowOverride: All

#delete-regular-host-to-register-ssl-certificate:
#  file.absent:
#    - name: /etc/httpd/conf.d/{{ pillar['fqdn'] }}.conf

delete-redirect-to-register-ssl-certificate:
  file.absent:
    - name: /etc/httpd/conf.d/{{ pillar['fqdn'] }}-redirect.conf

delete-ssl-to-register-certificate:
  file.absent:
    - name: /etc/httpd/conf.d/{{ pillar['fqdn'] }}-ssl.conf

stopapacheforcertbot:
  service.dead:
    - name: httpd

startapacheforcertbot:
  service.running:
    - name: httpd

#fix this
apache:
  user.present:
    - shell: /sbin/nologin

#inspectrbenv:
#  cmd.run:
#    - name: ls -lR /usr/local/rbenv
     
#installbundle:
#  cmd.run:
#    - name: su root -l -c "export PATH=/usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH && export RBENV_ROOT=/usr/local/rbenv && cd /opt/code/devopsrockstars-website && ruby --version && which gem && gem install bundle"
   
#installgems:
#  cmd.run:
    #- name: su apache -c "cd /opt/code/devopsrockstars-website && bundle install --deployment"
    #- name:  su apache -s /bin/bash -l -c "cd /opt/code/devopsrockstars-website && bundle install --deployment"
#    - name:  su apache -s /bin/bash -l -c "ruby --version && export PATH=/usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH && export RBENV_ROOT=/usr/local/rbenv && cd /opt/code/devopsrockstars-website && bundle install --deployment"
#    - stateful: False

#su apache -c "cd /opt/code/devopsrockstars-website && bundle exec rake devopsrockstars:updateloans":
#su apache -s /bin/bash -l -c "cd /opt/code/devopsrockstars-website && bundle exec rake devopsrockstars:updateloans":
#  cron.present:
#    - user: root
#    - minute: random
#    - hour: 2
#    - commented: False

#clobberassets:
#  cmd.run:
#    - name: su apache -s /bin/bash -l -c "cd /opt/code/devopsrockstars-website && bundle exec rake assets:clobber"

#cleartempassets:
#  cmd.run:
#    - name: su apache -s /bin/bash -l -c "cd /opt/code/devopsrockstars-website && bundle exec rake tmp:clear"

#compileassets:
#  cmd.run:
#    - name: su apache -s /bin/bash -l -c "export RAILS_ENV={{ pillar['environment'] }} && cd /opt/code/devopsrockstars-website && bundle exec rake assets:precompile"

/opt/certbot/:
  file.directory:
    - user: root
    - group: root
    - mode: 750
    - makedirs: True

/opt/certbot/log:
  file.directory:
    - user: root
    - group: root
    - mode: 750
    - makedirs: True

/opt/certbot/config:
  file.directory:
    - user: root
    - group: root
    - mode: 750
    - makedirs: True

/opt/certbot/work:
  file.directory:
    - user: root
    - group: root
    - mode: 750
    - makedirs: True

restartapache:
  cmd.run:
    - name: service httpd restart
    - stateful: False

getcrt:
  cmd.run:
    - stateful: False
    #- name: sudo su - apache -c "certbot certonly -n --webroot -w /opt/code/devopsrockstars-website/public -d {{ pillar['fqdn'] }} --logs-dir=/opt/certbot/logs --config-dir=/opt/certbot/config --work-dir=/opt/certbot/work --email=webmaster@devopsrockstars.com --agree-tos"
    #- name: certbot certonly -n --webroot -w /opt/code/devopsrockstars-website/public -d {{ pillar['fqdn'] }} --logs-dir=/opt/certbot/logs --config-dir=/opt/certbot/config --work-dir=/opt/certbot/work --email=webmaster@devopsrockstars.com --agree-tos
    - name: {{ pillar['certbot_path'] }} certonly -n --webroot -w /var/www/html -d {{ pillar['fqdn'] }} -d {{ pillar['fqdn2'] }}  --logs-dir=/opt/certbot/logs --config-dir=/opt/certbot/config --work-dir=/opt/certbot/work --email=webmaster@devopsrockstars.com --agree-tos --expand --hsts --post-hook 'apachectl restart' --debug
  
#sudo su - apache -c "certbot certonly -n --webroot -w /opt/code/devopsrockstars-website/public -d {{ pillar['fqdn'] }} --logs-dir=/opt/certbot/logs --config-dir=/opt/certbot/config --work-dir=/opt/certbot/work --email=webmaster@devopsrockstars.com --agree-tos":
{{ pillar['certbot_path'] }} certonly -n --webroot -w /opt/code/devopsrockstars-website/public -d {{ pillar['fqdn'] }} -d {{ pillar['fqdn2'] }} --logs-dir=/opt/certbot/logs --config-dir=/opt/certbot/config --work-dir=/opt/certbot/work --email=webmaster@devopsrockstars.com --agree-tos --expand --hsts --post-hook 'apachectl restart' --debug:
  cron.present:
    - user: root
    - minute: random
    - hour: 2
    - commented: False

/etc/httpd/conf.d/{{ pillar['fqdn'] }}-ssl.conf:
  apache.configfile:
    - config:
      - VirtualHost:
          this: '*:443'
          SSLEngine: 'on'
          #Header: set Access-Control-Allow-Origin "*"
          #Header: set Access-Control-Allow-Origin "https://d35vew6rpu90ot.cloudfront.net"
          #Header: set Access-Control-Allow-Origin "https://rose.devopsrockstars.com", "https://devopsrockstars.com"
          #Header: set Access-Control-Allow-Origin "https://{{ pillar['fqdn'] }}"
          #above gives this with chrome.
          #XMLHttpRequest cannot load https://d35vew6rpu90ot.cloudfront.net/assets/chicago-star-white-prompt-77760973a991253aa6a663271ed75b810b7371f44521ab6ca098cb035fbde6e2.svg. The 'Access-Control-Allow-Origin' header has a value 'https://d35vew6rpu90ot.cloudfront.net' that is not equal to the supplied origin. Origin 'https://rose.devopsrockstars.com' is therefore not allowed access.
          Header: set Access-Control-Allow-Origin "*"
          SSLCertificateFile: /opt/certbot/config/live/{{ pillar['fqdn'] }}/cert.pem
          SSLCertificateKeyFile: /opt/certbot/config/live/{{ pillar['fqdn'] }}/privkey.pem
          SSLCertificateChainFile: /opt/certbot/config/live/{{ pillar['fqdn'] }}/fullchain.pem
          SSLProtocol: all -SSLv2
          SSLCipherSuite: ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW
          ServerName:
            - {{ pillar['fqdn'] }}
          ServerAlias:
            - {{ pillar['fqdn2'] }}
          ErrorLog: logs/{{ pillar['fqdn'] }}-ssl-error_log
          CustomLog: logs/{{ pillar['fqdn'] }}-ssl-access_log combined
          DocumentRoot: /opt/code/devopsrockstars-website/public
          #PassengerRuby: /usr/bin/ruby
          PassengerRuby: /usr/local/rbenv/versions/2.3.0/bin/ruby
          PassengerRoot: /usr/local/rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/passenger-5.1.2
          PassengerMinInstances: 3
          PassengerPreStart: https://{{ pillar['fqdn'] }}
          RailsEnv: {{ pillar['environment'] }}
          AddType:
            - image/svg+xml svg svgz
          AddEncoding:
            - gzip svgz
          Directory:
            this: /opt/code/devopsrockstars-website/public
            Order:
              - allow,deny
            Allow from:
              - all
            Require:
              - all granted
            Satisfy:
              - Any
            ##double hashbangs were previous
            ##Allow from:
            ##  - all
            ##Options: 
            ##  - -MultiViews
            ##Require:
            ##  - all granted
            #Order: Deny,Allow
            #Deny from: all
            #Allow from:
            #  - 127.0.0.1
            #  - 192.168.100.0/24
            #Options:
            #  - +Indexes
            #  - FollowSymlinks
            #AllowOverride: All
          #https://coderwall.com/p/sx-8xa/serving-pre-compressed-assets-through-apache
          #Location:
          #  this: /assets/
          #  RewriteCond: '%{HTTP:Accept-Encoding} \b(x-)?gzip\b'
          #  #RewriteCond: '%{REQUEST_FILENAME}.gz -s'
          #  RewriteRule: 
          #    - '^(.+) $1.gz [L]'
          #  RewriteCond:
          #    - '%{HTTP:Accept-Encoding} \b(x-)?gzip\b'
          #    - '%{REQUEST_FILENAME}.gz -s'
          #  RewriteEngine:
          #    - 'on'
          #http://paste.debian.net/875782/
          #FilesMatch:
          #  - this: \.css\.gz$
          #    ForceType: text/css
          #    Header: set Content-Encoding gzip
          #  - this: \.js\.gz$
          #    ForceType: text/javascript
          #    Header: set Content-Encoding gzip

/etc/httpd/conf.d/{{ pillar['fqdn'] }}-passenger.conf:
  apache.configfile:
    - config:
      - LoadModule: 'passenger_module /usr/local/rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/passenger-5.1.2/buildout/apache2/mod_passenger.so'

/etc/httpd/conf.d/{{ pillar['fqdn'] }}-redirect.conf:
  apache.configfile:
    - config:
      - VirtualHost:
          this: '*:80'
          ServerName:
            - {{ pillar['fqdn'] }}
          ServerAlias:
            - {{ pillar['fqdn2'] }}
          Redirect: temporary / https://{{ pillar['fqdn2'] }}
          ErrorLog: logs/{{ pillar['fqdn'] }}-redirect-error_log
          CustomLog: logs/{{ pillar['fqdn'] }}-redirect-access_log combined

restartapache-after-installing-ssl:
  cmd.run:
    - name: service httpd restart
    - stateful: False
