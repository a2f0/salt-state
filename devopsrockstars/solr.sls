include:
  - solr.running

/opt/local/solr-4.9.1/example/solr/devopsrockstars/conf:
  file.directory:
    - user: root
    - group: root
    - makedirs: True
    - dir_mode: 755

deploy-schema:
  file.managed:
    - name: /opt/local/solr-4.9.1/example/solr/devopsrockstars/conf/schema.xml
    - user: root
    - source: salt://solr/devopsrockstars/schema.xml

deploy-solrconfig:
  file.managed:
    - name: /opt/local/solr-4.9.1/example/solr/devopsrockstars/conf/solrconfig.xml
    - user: root
    - source: salt://solr/devopsrockstars/solrconfig.xml

create-core:
    cmd.run: 
    - name: curl -L -X GET 'http://localhost:8983/solr/admin/cores?action=CREATE&name=devopsrockstars&instanceDir=/opt/local/solr-4.9.1/example/solr/devopsrockstars&config=solrconfig.xml&schema=schema.xml&dataDir=data'
    - require:
      - sls: solr.running 
      - cmd: delete-core
    - onchanges:
      - file: /opt/local/solr-4.9.1/example/solr/devopsrockstars/conf/schema.xml
      - file: /opt/local/solr-4.9.1/example/solr/devopsrockstars/conf/solrconfig.xml

delete-core:
   cmd.run:
    - name: curl -L -X GET 'http://localhost:8983/solr/admin/cores?action=UNLOAD&core=devopsrockstars&deleteIndex=true'
    - onlyif: curl -s -L -X GET 'http://localhost:8983/solr/admin/cores?action=STATUS&core=devopsrockstars' | grep -q dataDir
    - require_in:
        - cmd: create-core