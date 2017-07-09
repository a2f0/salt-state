include:
  - solr.installed

solr-running:
  cmd.run:
    - name: nohup java -DSTOP.PORT=8984 -DSTOP.KEY={{ pillar['solr_stopkey'] }} -jar /opt/local/solr-4.9.1/example/start.jar > /var/log/solr.log 2>&1 &
    - cwd: /opt/local/solr-4.9.1/example
    - unless: nc localhost 8983 < /dev/null
    - onchanges_in:
      - cmd: wait-for-solr-to-start
    - require:
      - sls: solr.installed
    - timeout: 60

wait-for-solr-to-start:
  cmd.run:
    - name: while ! nc localhost 8983 < /dev/null; do sleep 1 && echo "waiting for solr to start"; done
    - timeout: 10