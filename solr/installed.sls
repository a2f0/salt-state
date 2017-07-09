solr-deps:
  pkg.installed:
    - names:
      - java-1.7.0-openjdk
      - nc

create-solr-dir:
  file.directory:
    - name: /opt/local/solr-4.9.1
    - user: root
    - mode: 755
    - makedirs: True

download-tarball:
  file.managed:
    - name: /tmp/solr-4.9.1.tgz
    - source: https://archive.apache.org/dist/lucene/solr/4.9.1/solr-4.9.1.tgz
    - skip_verify: True
    - user: root

#downloading and extracting because had problems doing archive.extracted from https
extract-solr:
  archive.extracted:
    - name: /opt/local
    - source: /tmp/solr-4.9.1.tgz
    - user: root
    - onlyif: test -z "$(ls -A /opt/local/solr-4.9.1/*)"
    - require:
      - file: create-solr-dir