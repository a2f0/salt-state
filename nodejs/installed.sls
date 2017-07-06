{% if grains['os'] == 'Amazon' %}

include:
  - epel.install

#install it without having to permanetly enabling the repo
install-node:
  cmd:
    - run
    - name: yum install nodejs npm --enablerepo=epel
    - unless: test -f /usr/bin/node
    - require:
      - sls: epel.install

{% endif %}