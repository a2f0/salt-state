#explictly aws-cli on Amazon Linux (for Docker containers)
{% if grains['os'] == 'Amazon' %}

aws-cli:
  pkg.installed

{% else %}

aws-not-installing:
  test.nop

{% endif %}