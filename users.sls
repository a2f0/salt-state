include:
  #- pre-user-changes
  #- httpd.stop-for-modifying-apache-user
  - httpd.running
  - httpd.dead

{% for user in pillar['users'] %}

user_{{user.name}}:

  group.present:
    - name: {{user.name}}
    - gid: {{user.gid}}

  user.present:
    - name: {{user.name}}
    - fullname: {{user.fullname}}
    - password: {{user.shadow}}
    - home: {{user.home}}
    - shell: {{user.shell}}
    - uid: {{user.uid}}
    - gid: {{user.gid}}
    {% if user.groups %}
    - optional_groups:
      {% for group in user.groups %}
      - {{group}}
      {% endfor %}
    {% endif %}
    - require:
      - group: user_{{user.name}}
    #  - sls: pre-user-changes
    {% if user.name == "apache"  %}
    - prereq_in:
      - service: httpd-dead-user-change
    - onchanges_in:
      - service: httpd-running
    {% endif %}

  file.directory:
    - name: {{user.home}}
    - user: {{user.name}}
    - group: {{user.name}}
    - mode: 0750
    - makedirs: True

user_{{user.name}}_forward:
  file.append:
    - name: {{user.home}}/.forward
    - text: {{user.email}}

user_{{user.name}}_sshdir:
  file.directory:
    - name: {{user.home}}/.ssh
    - user: {{user.name}}
    - group: {{user.name}}
    - mode: 0700

{% if 'authkey' in user %}
user_{{user.name}}_authkeys:
  ssh_auth.present:
    - user: {{user.name}}
    - name: {{user.authkey}}
{% endif %}

{% if 'known_hosts' in user %}
  {% for known_host in user.known_hosts %}
known_host_{{user.name}}_{{loop.index0}}:
  ssh_known_hosts:
    - name: {{ known_host.name }}
    - present
    - user: {{user.name}}
    - enc: rsa
    - fingerprint: {{ known_host.fingerprint }}
  {% endfor %}
{% endif %}

user_{{user.name}}_gitconfig_email:
  git.config_set:
    - user: {{user.name}}
    - global: True
    - name: user.email
    - value: {{user.email}}

user_{{user.name}}_gitconfig_fullname:
  git.config_set:
    - user: {{user.name}}
    - global: True
    - name: user.name
    - value: {{user.fullname}}

user_{{user.name}}_gitconfig_pullrebase:
  git.config_set:
    - user: {{user.name}}
    - global: True
    - name: pull.rebase
    - value: true

{% if 'aws' in user %}

user_{{user.name}}_awsdir:
  file.directory:
    - name: {{user.home}}/.aws
    - user: {{user.name}}
    - group: {{user.name}}
    - mode: 0700

user_{{user.name}}_awscredentials:
  file.managed:
    - name: {{user.home}}/.aws/credentials
    - user: {{user.name}}
    - group: {{user.name}}
    - mode: 600

user_{{user.name}}_aws_credentials:
  file.append:
    - name: {{user.home}}/.aws/credentials
    - text:
      - '[default]'
      - aws_access_key_id={{user.aws.accesskey}}
      - aws_secret_access_key={{user.aws.secretaccesskey}}

{% endif %}

{% if 'sshpub' in user %}
user_{{user.name}}_sshpub:
  file.managed:
    - name: {{user.home}}/.ssh/id_rsa.pub
    - user: {{user.name}}
    - group: {{user.name}}
    - mode: 0600
    - contents: {{ user.sshpub }}
{% endif %}

{% if 'sshpriv' in user %}
user_{{user.name}}_sshpriv:
  file.managed:
    - name: {{user.home}}/.ssh/id_rsa
    - user: {{user.name}}
    - group: {{user.name}}
    - mode: 0600
    - contents: |
        {{ user.sshpriv | indent(8) }}
{% endif %}

{% endfor %} # user in users
