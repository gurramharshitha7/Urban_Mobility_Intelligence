/*
============================================================
PROJECT: Urban Mobility Intelligence
DATASET: NYC Yellow Taxi — 2025
PURPOSE: Prepare hourly taxi-weather data for Q8
============================================================
*/

USE NYC_Taxi_Analytics;
GO

/* =========================================================
   1. WEATHER TABLE
   ========================================================= */

CREATE TABLE weather_hourly (
    weather_hour DATETIME2,
    rainfall_mm DECIMAL(10,2),
    rain_flag BIT
);
GO

/* =========================================================
   2. AGGREGATE TAXI DATA TO HOURLY LEVEL
   ========================================================= */

SELECT
    DATEADD(
        hour,
        DATEDIFF(hour, 0, pickup_datetime),
        0
    ) AS taxi_hour,
    COUNT(*) AS total_trips,
    ROUND(AVG(trip_duration_minutes), 2) AS avg_duration_minutes,
    ROUND(AVG(avg_speed_mph), 2) AS avg_speed_mph
INTO taxi_hourly
FROM taxi_trips
GROUP BY
    DATEADD(
        hour,
        DATEDIFF(hour, 0, pickup_datetime),
        0
    );
GO

CREATE INDEX IX_taxi_hourly_hour
ON taxi_hourly (taxi_hour);
GO

CREATE INDEX IX_weather_hourly_hour
ON weather_hourly (weather_hour);
GO

/* =========================================================
   3. CREATE TAXI-WEATHER ANALYSIS TABLE
   ========================================================= */

SELECT
    t.taxi_hour,
    t.total_trips,
    t.avg_duration_minutes,
    t.avg_speed_mph,
    w.rainfall_mm,
    w.rain_flag
INTO taxi_weather_hourly
FROM taxi_hourly t
INNER JOIN weather_hourly w
    ON t.taxi_hour = w.weather_hour;
GO

/* =========================================================
   4. VALIDATION
   ========================================================= */

SELECT COUNT(*) AS matched_hours
FROM taxi_weather_hourly;
GO

/* =========================================================
   4. WEATHER IMPACT — CONTROLLED FOR TIME OF DAY
   Compare Rain vs No Rain within each hour
   ========================================================= */

IF OBJECT_ID('tempdb..#HourlyComparison') IS NOT NULL
    DROP TABLE #HourlyComparison;


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
)

SELECT
    r.hour_of_day,

    n.avg_trips AS no_rain_trips,
    r.avg_trips AS rain_trips,

    n.avg_duration AS no_rain_duration,
    r.avg_duration AS rain_duration,

    n.avg_speed AS no_rain_speed,
    r.avg_speed AS rain_speed,

    ((r.avg_trips - n.avg_trips)
        / NULLIF(n.avg_trips, 0)) * 100
        AS demand_pct_change,

    ((r.avg_duration - n.avg_duration)
        / NULLIF(n.avg_duration, 0)) * 100
        AS duration_pct_change,

    ((r.avg_speed - n.avg_speed)
        / NULLIF(n.avg_speed, 0)) * 100
        AS speed_pct_change

INTO #HourlyComparison

FROM HourlyWeather r
JOIN HourlyWeather n
    ON r.hour_of_day = n.hour_of_day
WHERE
    r.rain_flag = 1
    AND n.rain_flag = 0;


/* =========================================================
   RESULT 1 — PER-HOUR BREAKDOWN
   ========================================================= */

SELECT *
FROM #HourlyComparison
ORDER BY hour_of_day;


/* =========================================================
   RESULT 2 — OVERALL HOUR-CONTROLLED IMPACT
   ========================================================= */

SELECT
    ROUND(AVG(demand_pct_change), 2) AS avg_demand_pct_change,
    ROUND(AVG(duration_pct_change), 2) AS avg_duration_pct_change,
    ROUND(AVG(speed_pct_change), 2) AS avg_speed_pct_change,

    ROUND(STDEV(demand_pct_change), 2) AS demand_pct_std_dev,
    ROUND(STDEV(duration_pct_change), 2) AS duration_pct_std_dev,
    ROUND(STDEV(speed_pct_change), 2) AS speed_pct_std_dev

FROM #HourlyComparison;
GO