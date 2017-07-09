certbot-deps:
  pkg.installed:
    - names:
      - python27-virtualenv
      - libffi-devel

{% if 1 == salt['cmd.retcode']('test -f /usr/local/bin/certbot-auto') %}

/usr/local/bin/certbot-auto:
  file.managed:
    - name: /usr/local/bin/certbot-auto
    - user: root
    - group: root
    - mode: 750
    - source: https://dl.eff.org/certbot-auto
    - skip_verify: True
    - require:
      - pkg: certbot-deps

{% else %}

certbot-already-installed:
  test.nop

{% endif %}