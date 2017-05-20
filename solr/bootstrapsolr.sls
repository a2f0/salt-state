/tmp/solr-4.9.1.tgz:
  file.managed:
    - source: salt://solr-4.9.1.tgz
    #- user: root
    #- group: root

killexisting:
  cmd.run:
    - name: pkill java || true && sleep 10

startover:
  cmd.run:
    - name: rm -rf /tmp/solr-4.9.1

unpacktarball:
  cmd.run:
    - name: cd /tmp && tar -zxvf /tmp/solr-4.9.1.tgz
    - stateful: False

{% if grains['osfullname'] == 'Amazon Linux AMI' %}

java-1.7.0-openjdk:
  pkg.installed

nmap-ncat:
  pkg.installed

{% elif grains['os'] == 'MacOS' %}

netcat:
  pkg.installed

{% endif %}

createlogdir:
  cmd.run:
    - name: mkdir -p /tmp/solr-4.9.1/log
    - stateful: False

touchlog:
  cmd.run:
    - name: touch /tmp/solr-4.9.1/log/solr.log

startsolr:
  cmd.run:
    - name: nohup java -DSTOP.PORT=8984 -DSTOP.KEY=mysecret -jar /tmp/solr-4.9.1/example/start.jar > /tmp/solr-4.9.1/log/solr.log 2>&1 &
    - cwd: /tmp/solr-4.9.1/example/

waitforsolrtostart:
  cmd.run:
    - name: while ! echo exit | nc localhost 8983; do sleep 1 && echo "waiting for jetty to start"; done
    #- name: sleep 10
    - timeout: 60

deletedefaultcore:
  cmd.run:
    - name: curl -L -X GET 'http://localhost:8983/solr/admin/cores?action=UNLOAD&core=collection1&deleteIndex=true'

createcoredir:
  cmd.run:
    - name: mkdir -p /tmp/solr-4.9.1/example/solr/devopsrockstars/conf

/tmp/solr-4.9.1/example/solr/devopsrockstars/conf/schema.xml:
  file.managed:
    - source: salt://sunspot-solr-config/schema.xml
    #- user: root
    #- group: root

/tmp/solr-4.9.1/example/solr/devopsrockstars/conf/solrconfig.xml:
  file.managed:
    - source: salt://sunspot-solr-config/solrconfig.xml
    #- user: root
    #- group: root

createcore:
  cmd.run:
    - name: curl -L -X GET 'http://localhost:8983/solr/admin/cores?action=CREATE&name=devopsrockstars&instanceDir=/tmp/solr-4.9.1/example/solr/devopsrockstars&config=solrconfig.xml&schema=schema.xml&dataDir=data'

{% if grains['osfullname'] == 'Amazon Linux AMI' %}

reindex:
  cmd.run:
    - name: su apache -s /bin/bash -l -c "export RAILS_ENV={{ pillar['environment'] }} && cd /opt/code/devopsrockstars-website && bundle exec rake sunspot:reindex"

{% elif grains['os'] == 'MacOS' %}

reindex-dev:
  cmd.run:
    - name: cd /Users/dansullivan/working/github/devopsrockstars-new && bundle exec rake sunspot:reindex

{% endif %}
