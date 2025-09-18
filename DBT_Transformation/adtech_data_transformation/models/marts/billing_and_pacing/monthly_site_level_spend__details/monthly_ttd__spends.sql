
select *
from {{ ref('monthly__spends_and_pacing') }}
where site_name = 'TTD'
