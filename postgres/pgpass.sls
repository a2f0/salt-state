pgpass-permissions:
  file.managed:
    - name: /root/.pgpass
    - user: root
    - group: root
    - mode: 600

configurepgpass:
  file.append:
    - name: /root/.pgpass
    - text: localhost:5432:*:{{ pillar['pguser'] }}:{{ pillar['pgpass'] }} 
    - require:
      - file: pgpass-permissions