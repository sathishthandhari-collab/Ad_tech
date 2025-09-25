
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'AVZU'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        