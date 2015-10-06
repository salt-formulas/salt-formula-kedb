
include:
{% if pillar.kedb.server is defined %}
- kedb.server
{% endif %}
