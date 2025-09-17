-- 30 min bucket
with user_time_ranges as (
  select 
    user_id,
    date_trunc('hour', min("timestamp")) - interval '30 minutes' as min_time,
    date_trunc('hour', max("timestamp")) + interval '1 hour' as max_time
  from public.health_data
  group by user_id
),

user_buckets as (
  select 
    u.user_id,
    generate_series(
      u.min_time,
      u.max_time,
      interval '30 minutes'
    ) as bucket_start
  from user_time_ranges u
),

actual_data as (
  select 
    user_id,
    date_trunc('hour', "timestamp") + 
     case 
	  when extract(minute from "timestamp") >= 30 then interval '30 minutes' 
      else interval '0 minutes' 
     end as bucket_start,
	  
	count(*) as samples,
	round(avg(heart_rate),1) as heart_rate_avg,
	min(heart_rate_min) as heart_rate_min,
	max(heart_rate_max) as heart_rate_max,
	sum(steps) as steps_sum,
	round(avg(respiratory_rate),1) as respiratory_rate_avg,
	round(sum(activity_energy),1) as activity_energy_sum,
	round(sum(distance),2) as distance_sum

	from public.health_data
	group by user_id, bucket_start
)

select 
  ub.user_id,
  ub.bucket_start,
  coalesce(ad.samples, 0) as samples,
  ad.heart_rate_avg,
  ad.heart_rate_min,
  ad.heart_rate_max,
  ad.steps_sum,
  ad.respiratory_rate_avg,
  ad.activity_energy_sum,
  ad.distance_sum
from user_buckets ub
left join actual_data ad on ub.user_id = ad.user_id and ub.bucket_start = ad.bucket_start
order by ub.user_id, ub.bucket_start;