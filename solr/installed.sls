create-solr-dir:
  file.directory:
    - name: /opt/local/solr-4.9.1
    - user: root
    - mode: 700

extract_solr:
  archive.extracted:
    - name: /opt/local
    - source: https://archive.apache.org/dist/lucene/solr/4.9.1/solr-4.9.1.tgz
    - user: root
    - skip_verify: True
    - onlyif: test -z "$(ls -A /opt/local/solr-4.9.1/*)"