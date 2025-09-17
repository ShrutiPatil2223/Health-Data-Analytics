import psycopg2
from datetime import datetime, timedelta
import random

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname="health",
    user="postgres",
    password="pass",
    host="localhost",
    port="5432"
)
cur = conn.cursor()

now = datetime.now().replace(second=0, microsecond=0)
start = now - timedelta(hours=24)

users = ["1", "2", "3", "4", "5"]

for user in users:
    t = start
    while t <= now:
        if random.random() < 0.05:
            t += timedelta(minutes=1)
            continue  
        hr = random.randint(60, 110)
        hr_min = max(50, hr - random.randint(0, 10))
        hr_max = hr + random.randint(0, 15)
        hrv = round(random.uniform(20, 120), 1)
        resp = round(random.uniform(10, 20), 1)
        steps = random.randint(0, 20) if 7 <= t.hour < 21 else 0
        activity_energy = round(steps * random.uniform(0.03, 0.08), 2)
        basal_energy = round(random.uniform(1.0, 2.0), 2)
        distance = round(steps * random.uniform(0.6, 0.9) / 1000.0, 4)
        flights = random.randint(0, 1) if random.random() < 0.01 else 0
        exercise = 1 if (7 <= t.hour < 21 and random.random() < 0.2) else 0
        stand_hour = 1 if t.minute == 0 and 7 <= t.hour < 21 else 0
        workout = 1 if t.minute == 0 and random.random() < 0.01 else 0
        walking_hr_avg = hr if steps > 0 else None
        cycling_distance = round(random.uniform(0, 0.5), 3) if random.random() < 0.01 else 0.0

        cur.execute("""
            INSERT INTO public.health_data (
                user_id, "timestamp", heart_rate, heart_rate_min, heart_rate_max,
                heart_rate_variability, respiratory_rate, steps,
                activity_energy, basal_energy, distance, flights_climbed,
                exercise_minutes, stand_hours, workout_count,
                walking_heart_rate_avg, cycling_distance
            ) VALUES (
                %s, %s, %s, %s, %s,
                %s, %s, %s,
                %s, %s, %s, %s,
                %s, %s, %s,
                %s, %s
            )
        """, (
            user, t, hr, hr_min, hr_max,
            hrv, resp, steps,
            activity_energy, basal_energy, distance, flights,
            exercise, stand_hour, workout,
            walking_hr_avg, cycling_distance
        ))

        t += timedelta(minutes=1)

conn.commit()
cur.close()
conn.close()
print("data inserted.")

