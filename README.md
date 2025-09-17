# Health-Data-Analytics

## SETUP INSTRUCTIONS

These are the steps I followed to create the health data case study project.

Tools I Used:
- PostgreSQL (installed locally)
- pgAdmin4 
- Python (via VS Code)

SETUP STEPS:
1. Installed PostgreSQL and pgAdmin4 on your computer.
2. Created a database - "health" using pgAdmin 4.
3. Inside the database, created the table.
4. Wrote the Python script to generate dummy data in VS Code.
5. Ran the script — it will insert realistic 24 hours of fitness data for 5 users into the table.
6. Used pgAdmin4 to query the data

Assumptions:
- I simulated 5 users wearing fitness trackers.
- Each user has 1 row of data per minute for 24 hours with 5% data missing to incorporate the missing connection of the Apple Watch.
- Added the data included in the assignment to the realistic base.
