solr-stopped:
  cmd.run:
    - name: java -DSTOP.PORT=8984 -DSTOP.KEY={{ pillar['solr_stopkey'] }} -jar /opt/local/solr-4.9.1/example/start.jar --stop
    - onlyif: nc localhost 8983 < /dev/null
    - onchanges_in:
      - cmd: wait-for-solr-to-stop

wait-for-solr-to-stop:
  cmd.run:
    - name: while nc localhost 8983 < /dev/null; do sleep 1 && echo "waiting for solr to stop"; done
    - timeout: 10