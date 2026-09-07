/*
============================================================
PROJECT: Urban Mobility Intelligence
DATASET: NYC Yellow Taxi — 2025
DATABASE: NYC_Taxi_Analytics

PURPOSE:
Analyze taxi demand, operational performance,
geographic patterns, and weather-related effects.

TOOLS:
Python | SQL Server | Power BI
============================================================
*/

USE NYC_Taxi_Analytics;
GO

/* =========================================================
   1. ANALYTICAL QUERIES
   ========================================================= */

-- Q1. When is taxi demand highest during the day?

SELECT
    pickup_hour,
    COUNT(*) AS total_trips
FROM taxi_trips
GROUP BY pickup_hour
ORDER BY pickup_hour;

-- Q2. How does average daily taxi demand differ between weekdays and weekends?

SELECT
    day_type,
    COUNT(*) * 1.0 / COUNT(DISTINCT pickup_date) AS avg_daily_trips
FROM taxi_trips
GROUP BY day_type
ORDER BY avg_daily_trips DESC;

-- Q3. Which pickup zones generate the highest taxi demand?

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
ORDER BY total_trips DESC;

-- Q4. How do trip duration and average speed vary across demand hours?

SELECT
    pickup_hour,
    COUNT(*) AS total_trips,
    ROUND(AVG(trip_duration_minutes), 2) AS avg_duration_minutes,
    ROUND(AVG(avg_speed_mph), 2) AS avg_speed_mph
FROM taxi_trips
GROUP BY pickup_hour
ORDER BY pickup_hour;

-- Q5. How does taxi demand vary across the months of 2025?

SELECT
    MONTH(pickup_date) AS pickup_month,
    COUNT(*) AS total_trips
FROM taxi_trips
GROUP BY MONTH(pickup_date)
ORDER BY pickup_month;

-- Q6. Which routes (pickup → drop-off zones) have the highest demand?

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
ORDER BY total_trips DESC;

-- Q7. How does trip performance vary by borough?

SELECT
    z.borough,
    COUNT(*) AS total_trips,
    ROUND(AVG(t.trip_duration_minutes), 2) AS avg_duration_minutes,
    ROUND(AVG(t.avg_speed_mph), 2) AS avg_speed_mph
FROM taxi_trips t
JOIN taxi_zones z
    ON t.pickup_location_id = z.location_id
GROUP BY z.borough
ORDER BY total_trips DESC;

/* =========================================================
   8. HOURLY WEATHER COMPARISON
   Rain vs No Rain by hour of day
   Used for Page 3 – Weather Impact
   ========================================================= */

CREATE OR ALTER VIEW pbi_weather_hourly_comparison AS
SELECT
    DATEPART(HOUR, taxi_hour) AS hour_of_day,
    rain_flag,
    CASE
        WHEN rain_flag = 1 THEN 'Rain'
        ELSE 'No Rain'
    END AS weather_condition,
    AVG(CAST(total_trips AS FLOAT)) AS avg_trips,
    AVG(CAST(avg_duration_minutes AS FLOAT)) AS avg_duration_minutes,
    AVG(CAST(avg_speed_mph AS FLOAT)) AS avg_speed_mph
FROM taxi_weather_hourly
GROUP BY DATEPART(HOUR, taxi_hour),
    rain_flag;
GO

/* =========================================================
   9. WEATHER IMPACT KPIs — CONTROLLED FOR TIME OF DAY
   Average percentage impact of rain within the same hour
   Used for Page 3 KPI cards
   ========================================================= */

CREATE OR ALTER VIEW pbi_weather_impact_kpis AS

WITH HourlyWeather AS (
    SELECT
        DATEPART(HOUR, taxi_hour) AS hour_of_day,
        rain_flag,
        AVG(CAST(total_trips AS FLOAT)) AS avg_trips,
        AVG(CAST(avg_duration_minutes AS FLOAT)) AS avg_duration,
        AVG(CAST(avg_speed_mph AS FLOAT)) AS avg_speed
    FROM taxi_weather_hourly
    GROUP BY
        DATEPART(HOUR, taxi_hour),
        rain_flag
),

HourlyComparison AS (
    SELECT
        ((r.avg_trips - n.avg_trips)
            / NULLIF(n.avg_trips, 0)) * 100
            AS demand_pct_change,

        ((r.avg_duration - n.avg_duration)
            / NULLIF(n.avg_duration, 0)) * 100
            AS duration_pct_change,

        ((r.avg_speed - n.avg_speed)
            / NULLIF(n.avg_speed, 0)) * 100
            AS speed_pct_change

    FROM HourlyWeather r
    JOIN HourlyWeather n
        ON r.hour_of_day = n.hour_of_day
    WHERE
        r.rain_flag = 1
        AND n.rain_flag = 0
)

SELECT
    ROUND(AVG(demand_pct_change), 2) AS demand_pct_change,
    ROUND(AVG(duration_pct_change), 2) AS duration_pct_change,
    ROUND(AVG(speed_pct_change), 2) AS speed_pct_change

FROM HourlyComparison;
GO


SELECT 'pbi_weather_impact_kpis', COUNT(*)
FROM pbi_weather_impact_kpis