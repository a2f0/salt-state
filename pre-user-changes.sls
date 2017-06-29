{% if user is defined %}
noop-pre-is-defined:
  test.succeed_without_changes
{% else %}
noop-pre-is-not-defined:
  test.succeed_without_changes
{% endif %}
