at:
  pkg.installed

downloadpagespeed:
  cmd.run:
    - name: wget -q https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_x86_64.rpm -O /tmp/mod-pagespeed-stable_current_x86_64.rpm

installpagespeed:
  cmd.run:
    - name: sudo rpm --quiet -U /tmp/mod-pagespeed-*.rpm || true

/etc/httpd/conf.d/pagespeed.conf:
  file.managed:
      - source: salt://configurations/pagespeed.conf
      - group: root
      - owner: root
      - mode: 644

bounceapacheafterinstallingpagespeed:
  cmd.run:
    - name: service httpd restart
    - stateful: False
