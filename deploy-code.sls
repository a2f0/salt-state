#clearoldcode:
#  cmd.run:
#    - name: rm -rf /opt/code/devopsrockstars-website

/opt/code/devopsrockstars-website:
  file.recurse:
    - clean: False
    - source: {{ pillar['sitesourcepath'] }}
    - include_empty: True
    - user: apache
    - group: apache
    - exclude_pat: .git/*
    #- exclude_pat: (.git/*)
#"*.git*" appears to work.

installbundle:
  cmd.run:
    - name: su root -l -c "export PATH=/usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH && export RBENV_ROOT=/usr/local/rbenv && cd /opt/code/devopsrockstars-website && ruby --version && which gem && gem install bundle"
   
installgems:
  cmd.run:
    #- name: su apache -c "cd /opt/code/devopsrockstars-website && bundle install --deployment"
    #- name:  su apache -s /bin/bash -l -c "cd /opt/code/devopsrockstars-website && bundle install --deployment"
    - name:  su apache -s /bin/bash -l -c "ruby --version && export PATH=/usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH && export RBENV_ROOT=/usr/local/rbenv && cd /opt/code/devopsrockstars-website && bundle install --deployment"
    - stateful: False

#su apache -c "cd /opt/code/devopsrockstars-website && bundle exec rake devopsrockstars:updateloans":
su apache -s /bin/bash -l -c "cd /opt/code/devopsrockstars-website && bundle exec rake devopsrockstars:updateloans":
  cron.present:
    - user: root
    - minute: random
    - hour: 2
    - commented: False

clobberassets:
  cmd.run:
    - name: su apache -s /bin/bash -l -c "cd /opt/code/devopsrockstars-website && bundle exec rake assets:clobber"
    - env:

cleartempassets:
  cmd.run:
    - name: su apache -s /bin/bash -l -c "cd /opt/code/devopsrockstars-website && bundle exec rake tmp:clear"
    - env:

compileassets:
  cmd.run:
    - name: su apache -s /bin/bash -l -c "export RAILS_ENV={{ pillar['environment'] }} && cd /opt/code/devopsrockstars-website && bundle exec rake assets:precompile"
    - env:

