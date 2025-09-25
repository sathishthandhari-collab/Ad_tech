
select * from adtech_analytics.thd_billing_prod.monthly__spends_and_pacing
where
    site_name = 'TOI'

    
        and month >= date_trunc('month', current_date) - interval '1 month'
        