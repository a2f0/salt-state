/opt/code/devopsrockstars.com/config/application.yml:
    file.serialize:
      - dataset:
          {{ pillar['fqdn2'] }}:
            braintree_merchant_id: {{ pillar['braintree_merchant_id'] }}
            braintree_public_key: {{ pillar['braintree_public_key'] }}
            braintree_private_key: {{ pillar['braintree_private_key'] }}
            secret_token: {{ pillar['secret_token'] }}
            devise_secret_key: {{ pillar['devise_secret_key'] }}
      - formatter: yaml
      - user: apache
      - group: apache
      - mode: 640