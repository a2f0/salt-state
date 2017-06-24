include:
  - pre-user-changes

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
      - sls: pre-user-changes

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

{% if user.name is defined %}
user_{{user.name}}_noop-pre-is-defined:
  test.succeed_without_changes
{% else %}
user_{{user.name}}_noop-pre-not-defined:
  test.succeed_without_changes
{% endif %}

{% if user.name == "apache"  %}
this-is-apache:
  test.succeed_without_changes
{% endif %}

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
