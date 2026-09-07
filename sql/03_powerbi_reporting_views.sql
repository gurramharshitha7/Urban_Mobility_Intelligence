USE NYC_Taxi_Analytics;
GO

/* =========================================================
   POWER BI REPORTING LAYER
   Creates lightweight views from the cleaned SQL data.
   These views are designed for Power BI import.
   ========================================================= */


/* =========================================================
   1. HOURLY DEMAND & PERFORMANCE
   Used for Q1 and Q4
   ========================================================= */

CREATE OR ALTER VIEW pbi_hourly AS
SELECT
    pickup_hour,
    COUNT(*) AS total_trips,
    ROUND(AVG(trip_duration_minutes), 2) AS avg_duration_minutes,
    ROUND(AVG(avg_speed_mph), 2) AS avg_speed_mph
FROM taxi_trips
GROUP BY pickup_hour;
GO


/* =========================================================
   2. DAILY DEMAND
   Used for Q2
   ========================================================= */

CREATE OR ALTER VIEW pbi_daily AS
SELECT
    pickup_date,
    day_name,
    day_type,
    COUNT(*) AS total_trips
FROM taxi_trips
GROUP BY
    pickup_date,
    day_name,
    day_type;
GO


/* =========================================================
   3. MONTHLY DEMAND
   Used for Q5
   ========================================================= */

CREATE OR ALTER VIEW pbi_monthly AS
SELECT
    MONTH(pickup_date) AS pickup_month,
    COUNT(*) AS total_trips
FROM taxi_trips
GROUP BY
    MONTH(pickup_date);
GO


/* =========================================================
   4. TOP PICKUP ZONES
   Used for Q3
   ========================================================= */

CREATE OR ALTER VIEW pbi_zones AS
SELECT TOP 10
    t.pickup_location_id,
    z.zone,
    z.borough,
    COUNT(*) AS total_trips
FROM taxi_trips t
JOIN taxi_zones z
    ON t.pickup_location_id = z.location_id
GROUP BY
    t.pickup_location_id,
    z.zone,
    z.borough
ORDER BY
    COUNT(*) DESC;
GO

/* =========================================================
   5. PEAK HOUR PICKUP ZONES
   Top pickup zones during the busiest hour (6 PM)
   ========================================================= */

CREATE OR ALTER VIEW pbi_peak_hour_zones AS
SELECT TOP 10
    t.pickup_location_id,
    z.zone,
    z.borough,
    COUNT(*) AS total_trips
FROM taxi_trips t
JOIN taxi_zones z
    ON t.pickup_location_id = z.location_id
WHERE t.pickup_hour = 18
GROUP BY
    t.pickup_location_id,
    z.zone,
    z.borough
ORDER BY
    COUNT(*) DESC;
GO

/* =========================================================
   6. TOP ROUTES
   Used for Q6
   ========================================================= */

CREATE OR ALTER VIEW pbi_routes AS
SELECT TOP 10
    p.zone AS pickup_zone,
    d.zone AS dropoff_zone,
    p.borough AS pickup_borough,
    d.borough AS dropoff_borough,
    COUNT(*) AS total_trips
FROM taxi_trips t
JOIN taxi_zones p
    ON t.pickup_location_id = p.location_id
JOIN taxi_zones d
    ON t.dropoff_location_id = d.location_id
GROUP BY
    p.zone,
    d.zone,
    p.borough,
    d.borough
ORDER BY
    COUNT(*) DESC;
GO


/* =========================================================
   7. BOROUGH PERFORMANCE
   Used for Q7
   ========================================================= */

CREATE OR ALTER VIEW pbi_borough AS
SELECT
    z.borough,
    COUNT(*) AS total_trips,
    ROUND(AVG(t.trip_duration_minutes), 2) AS avg_duration_minutes,
    ROUND(AVG(t.avg_speed_mph), 2) AS avg_speed_mph
FROM taxi_trips t
JOIN taxi_zones z
    ON t.pickup_location_id = z.location_id
GROUP BY
    z.borough;
GO


/* =========================================================
   8. WEATHER IMPACT
   Used for Q8
   ========================================================= */

CREATE OR ALTER VIEW pbi_weather AS
SELECT
    CASE
        WHEN rain_flag = 1 THEN 'Rain'
        ELSE 'No Rain'
    END AS weather_condition,
    COUNT(*) AS hours,
    ROUND(AVG(total_trips), 0) AS avg_hourly_trips,
    ROUND(AVG(avg_duration_minutes), 2) AS avg_duration_minutes,
    ROUND(AVG(avg_speed_mph), 2) AS avg_speed_mph
FROM taxi_weather_hourly
GROUP BY
    rain_flag;
GO


/* =========================================================
   9. VERIFY REPORTING LAYER
   ========================================================= */
SELECT 'pbi_hourly' AS view_name, COUNT(*) AS row_count
FROM pbi_hourly

UNION ALL

SELECT 'pbi_daily', COUNT(*)
FROM pbi_daily

UNION ALL

SELECT 'pbi_monthly', COUNT(*)
FROM pbi_monthly

UNION ALL

SELECT 'pbi_zones', COUNT(*)
FROM pbi_zones

UNION ALL

SELECT 'pbi_peak_hour_zones', COUNT(*)
FROM pbi_peak_hour_zones

UNION ALL

SELECT 'pbi_routes', COUNT(*)
FROM pbi_routes

UNION ALL

SELECT 'pbi_borough', COUNT(*)
FROM pbi_borough

UNION ALL

SELECT 'pbi_weather', COUNT(*)
FROM pbi_weather;
GO