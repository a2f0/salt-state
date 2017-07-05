include:
  - devopsrockstars.website
  - passenger.restart-app

/opt/code/devopsrockstars.com/config/application.yml:
    file.serialize:
      - dataset:
          {{ pillar['environment'] }}:
            braintree_merchant_id: {{ pillar['braintree_merchant_id'] }}
            braintree_public_key: {{ pillar['braintree_public_key'] }}
            braintree_private_key: {{ pillar['braintree_private_key'] }}
            secret_token: {{ pillar['secret_token'] }}
            devise_secret_key: {{ pillar['devise_secret_key'] }}
      - formatter: yaml
      - user: apache
      - group: apache
      - mode: 640
      - onchanges_in:
        - cmd: restart-passenger-app
      - require:
        - git: devopsrockstars-code

/opt/code/devopsrockstars.com/config/database.yml:
    file.serialize:
      - dataset:
          {{ pillar['environment'] }}:
            adapter: postgresql
            encoding: unicode
            pool: 5
            host: localhost
            port: 5432
            database: {{ pillar['pgdatabase'] }}
            username: {{ pillar['pguser'] }}
            password: {{ pillar['pgpass'] }}
      - formatter: yaml
      - user: apache
      - group: apache
      - mode: 640
      - onchanges_in:
        - cmd: restart-passenger-app
      - require:
        - git: devopsrockstars-code