file:
  pkg.installed

/opt:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755

/opt/code:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - require:
      - file: /opt