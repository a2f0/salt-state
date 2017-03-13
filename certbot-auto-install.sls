{% if 1 == salt['cmd.retcode']('test -f /usr/local/bin/certbot-auto') %}

install-certbot-auto:
  cmd.run:
    - name: curl -O https://dl.eff.org/certbot-auto -o /usr/local/bin/certbot-auto && chmod +x /usr/local/bin/certbot-auto && ls -l /usr/local/bin/certbot-auto
    - cwd: /
    - stateful: False

{% else %}

not-installing-certbot-auto:
  test.nop

{% endif %}
