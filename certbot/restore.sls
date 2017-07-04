include:
  - baseline
  - users
  
/opt/certbot:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 750
    - require:
      - file: /opt

restore-certbot:
  cmd.run:
    - name: echo "directory empty"
    - onlyif: test -z "$(ls -A /opt/certbot/*)"
    - require:
      - user: root
