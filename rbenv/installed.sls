rbenv-deps:
  pkg.installed:
    - names:
      - bzip2
      - gcc
      - openssl-devel
      - readline-devel
      - zlib-devel

ruby-2.3.0:
  rbenv.installed:
    - default: True
    - user: apache
    - require:
      - pkg: rbenv-deps

create-rbenv-global-profile:
  file.managed:
    - name: /home/apache/.profile
    - user: apache
    - group: apache
    - mode: 660

configure-rbenv-profile:
  file.append:
    - name: /home/apache/.profile
    - text: export PATH="~/.rbenv/bin:$PATH"

export-rbenv-global-profile:
  file.append:
    - name: /home/apache/.profile
    - text: export RBENV_ROOT=~/.rbenv
