{% if grains['os'] == 'Amazon' %}

epel-release:
  pkg.installed:
    - names:
      - epel-release

enable-epel-release:
  pkgrepo.managed:
    - name: epel
    - enabled: False

{% endif %}

