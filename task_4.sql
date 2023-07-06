with daily_order_history as (
    select dt,
           clientid,
           cnt,
           cityname,
           case when cnt > 0 then 1 else 0 end ord_flg
    from  (select dt,
                 clientid,
                 cityname,
                 count(distinct order_id) as cnt
          from test_df
          group by dt,
                   clientid,
                   cityname
          )
),

core_clients as (
  select distinct dt as start_dt,
         dt - 30 as end_dt,
         cityname,
         clientid       
  from test_df 
)

select cityname,
       start_dt as dt,
       cityname,
       count(distinct clientid) as clients_30d
from       
    (select cr_cl.start_dt,
           cr_cl.end_dt,
           cr_cl.clientid,
           ord_hist.ord_flg             
    from core_clients cr_cl         
    inner join daily_order_history ord_hist on cr_cl.clientid = ord_hist.clientid
                                              and ord_hist.dt >= cr_cl.end_dt
                                              and ord_hist.dt <= cr_cl.start_dt
                                              and ord_hist.cityname = cr_cl.cityname
    )
group by cityname,
         start_dt

order by cityname ASC,
         start_dt ASC 