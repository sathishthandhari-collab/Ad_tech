{% macro extract_campaign_attribute(column_name, position, delimiter='_') %}
  split_part({{ column_name }}, '{{ delimiter }}', {{ position }})
{% endmacro %}
