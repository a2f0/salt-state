#passenger-install-apache2-module --auto
#yum install httpd-devel
#gem install passenger --no-rdoc --no-ri -v=5.1.2


httpd-devel:
  pkg.installed

addressable:
  gem.installed:
    - name: passenger
    - ruby: 2.3.0

{% if 1 == salt['cmd.retcode']('test -f /usr/local/rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/passenger-5.1.2/buildout/apache2/mod_passenger.so') %}

{% set current_path = salt['environ.get']('PATH', '/bin:/usr/bin') %}

install-passenger-module:
  cmd.run:
    - name: passenger-install-apache2-module --auto
    - env:
      - PATH: {{ ['/usr/local/rbenv/bin:/usr/local/rbenv/shims', current_path ]|join(':') }}
      - RBENV_ROOT: "/usr/local/rbenv"

{% else %}

not-building-mod-passenger:
  test.nop

{% endif %}
