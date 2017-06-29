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
