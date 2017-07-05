{% if grains['os'] == 'Amazon' %}
base-packages:
  pkg.installed:
  - pkgs:
    - file
{% endif %}

/opt:
  file.directory:
    - user: root
    - group: wheel
    - dir_mode: 755

/opt/code:
  file.directory:
    - user: root
    - group: wheel
    - dir_mode: 755
    - require:
      - file: /opt
