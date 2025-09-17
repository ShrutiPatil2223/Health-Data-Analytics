CREATE TABLE public.health_data (
id bigserial PRIMARY KEY,
user_id text NOT NULL,
"timestamp" timestamp without time zone NOT NULL,
heart_rate integer,
heart_rate_min integer,
heart_rate_max integer,
heart_rate_variability numeric,

respiratory_rate numeric,
steps integer,
activity_energy numeric,
basal_energy numeric,
distance numeric,
flights_climbed integer,
exercise_minutes integer,
stand_hours integer,
workout_count integer,
walking_heart_rate_avg numeric,
cycling_distance numeric
);


