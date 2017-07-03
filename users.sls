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
