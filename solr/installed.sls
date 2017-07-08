rbenv-deps:
  pkg.installed:
    - names:
      - java-1.7.0-openjdk
      - nc

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

solr-running:
  cmd.run:
    - name: nohup java -DSTOP.PORT=8984 -DSTOP.KEY=mysecret -jar /opt/local/solr-4.9.1/example/start.jar > /var/log/solr.log 2>&1 &
    - cwd: /opt/local/solr-4.9.1/example
    - unless: nc localhost 8983 < /dev/null
  