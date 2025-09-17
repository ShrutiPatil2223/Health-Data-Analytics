-- 15 min bucket agg

with bucket as(
	select 
	user_id,
	case
		when extract(minute from "timestamp") < 15 then date_trunc('hour', "timestamp")
		when extract(minute from "timestamp") < 30 then date_trunc('hour',"timestamp") + interval '15 minutes'
		when extract(minute from "timestamp") < 45 then date_trunc('hour',"timestamp")+ interval '30 minutes'
		else date_trunc('hour', "timestamp") + interval '45 minutes'
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
	Group by user_id, bucket_start
)

select * 
from bucket
order by user_id, bucket_start
