#https://docs.saltstack.com/en/2015.8/ref/states/all/salt.states.rbenv.html
#https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.rbenv.html

#Mod passenger doesn't work with Amazon Linux, this is documented here
#https://www.phusionpassenger.com/library/install/apache/install/oss/el7/
#mod_passenger:
#  pkg.installed

rbenv-deps:
  pkg.installed:
    - names:
      - bzip2
      - readline-devel

ruby-2.3.0:
  rbenv.installed:
    - default: True
    - require:
      - pkg: rbenv-deps

create-rbenv-global-profile:
  file.managed:
    - name: /etc/profile.d/rbenv.sh
    - user: root
    - group: root
    - mode: 644

configure-rbenv-global-profile:
  file.append:
    - name: /etc/profile.d/rbenv.sh
    - text: export PATH="/usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH"

export-rbenv-global-profile:
  file.append:
    - name: /etc/profile.d/rbenv.sh
    - text: export RBENV_ROOT=/usr/local/rbenv
