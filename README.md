# Urban Mobility Intelligence | NYC Yellow Taxi (2025)

Built as part of my transition from a **backend development background into data analytics**, this end-to-end portfolio project analyzes **45 million NYC Yellow Taxi trips from 2025** to understand demand patterns, geographic concentration, weather-related mobility changes, and operational insights.

**Analytics workflow:**  
**Python → Data Cleaning \& Feature Engineering → SQL Server → Power BI → Business Insights**

## 🔗 Links

* **LinkedIn:** [www.linkedin.com/in/gurram-harshitha-939179277/](https://www.linkedin.com/in/gurram-harshitha-939179277/)
* **GitHub Profile:** [github.com/gurramharshitha7](https://github.com/gurramharshitha7)

> The project can also be explored directly from this repository using the included Power BI `.pbix` file.

---

## Project Overview

NYC taxi activity changes significantly by **hour, day, location, and weather conditions**. This project transforms large-scale trip-level data into an interactive Power BI report that answers questions such as:

* When is taxi demand highest?
* Which pickup zones and routes generate the most trips?
* How does demand shift during the evening peak?
* How do trip duration and travel speed change during rain?
* Which boroughs combine high demand with different mobility characteristics?
* What operational insights can be drawn while staying within the limits of trip-level data?

---

## Key Business Questions

### Demand

* How does taxi demand vary by hour of the day?
* Which months and days of the week have the highest activity?
* When does the daily demand peak occur?

### Geography

* Which pickup zones generate the highest trip volumes?
* Which routes are most frequently travelled?
* How do the top pickup zones change during the peak hour?
* How do demand, average speed, and trip duration differ across boroughs?

### Weather Impact

* Does rain change taxi demand when compared at the same hour of the day?
* How does rain affect trip duration?
* How does rain affect average travel speed?

---

## Tools \& Technologies

|Tool|Usage|
|-|-|
|**Python**|Data cleaning, transformation and feature engineering|
|**Pandas**|Data manipulation and analysis|
|**SQL Server**|Data storage and reporting views|
|**SQL**|Aggregation and analytical reporting queries|
|**Power BI**|Data modelling, DAX measures and dashboard development|
|**Jupyter Notebook**|Data preparation workflow|

---

## Data Sources

The analysis combines:

* **NYC Yellow Taxi Trip Records** — 2025 trip-level pickup, drop-off and trip performance data.
* **NYC Taxi Zone Lookup** — zone names and borough classifications for geographic analysis.
* **Hourly Weather Data** — weather observations matched with taxi activity to analyze rain-related demand and mobility impacts.
* **NYC Yellow Taxi Data Dictionary** — reference documentation used to understand trip record fields, definitions and data structure.

---

# Dashboard

## 1\. Overview

The overview page summarizes the scale of NYC Yellow Taxi activity and highlights major temporal demand patterns.

### Key Metrics

* **45M Total Trips**
* **124.13K Average Daily Trips**
* **16.62 minutes Average Trip Duration**
* **11.94 mph Average Speed**

The analysis shows a strong evening demand peak, with the highest activity occurring around **6 PM**. Demand also varies meaningfully across months and days of the week.

![Overview Dashboard](images/01\_overview.png)

---

## 2\. Demand \& Geography

This page explores where taxi demand is concentrated and how geographic patterns change during the peak hour.

Key views include:

* Top 10 pickup zones by trip volume
* Borough demand and performance
* Top 10 routes by trip volume
* Top 10 pickup zones at the **6 PM peak hour**

A notable finding is that **Midtown Center becomes the highest-demand pickup zone at the 6 PM peak**, while **Upper East Side South leads overall trip volume**, showing that demand geography changes during peak periods.

![Demand \& Geography Dashboard](images/02\_demand\_geography.png)

---

## 3\. Weather Impact

Weather observations were matched with taxi activity to compare **rain vs no-rain conditions by hour of day**.

### Key Findings

* **Demand increases by 17.6% during rain** when controlled for time of day.
* **Average trip duration increases by 5.1%.**
* **Average travel speed decreases by 9.2%.**

Together, these changes indicate greater mobility pressure during rainy periods: more trips are requested while journeys take longer and travel speeds decline.

![Weather Impact Dashboard](images/03\_weather\_impact.png)

---

## 4\. Data \& Methodology

The project follows an end-to-end analytics pipeline:

**Collect → Clean → Transform → Model \& Report**

### Data Cleaning \& Transformation

* Removed records outside the 2025 analysis period.
* Filtered invalid trip records and unrealistic trip duration or speed values.
* Created analytical features including:

  * Pickup hour
  * Day name
  * Day type
  * Trip duration
  * Average speed
* Enriched trip records using taxi zone and borough lookup data.
* Loaded cleaned data into SQL Server and created reporting views for Power BI.

![Data \& Methodology Dashboard](images/04\_data\_methodology.png)

---

## 5\. Recommendations \& Limitations

The final page translates findings into practical, data-supported considerations.

### Recommendations

* Prioritize operational attention during the evening demand peak.
* Use hourly demand patterns to support capacity planning.
* Focus on high-demand pickup zones, especially during peak periods.
* Use weather-aware ETAs and flag rainy periods for capacity planning.
* Monitor geographic demand concentration and zone-level demand patterns.

### Important Limitations

* The analysis is based on **2025 data only** and does not confirm long-term recurring patterns.
* Weather matching covers approximately **65% of the 2025 analysis period**.
* The analysis includes **NYC Yellow Taxi trips only** and does not represent the complete transportation market.
* The project focuses on **demand and mobility patterns**; fare and revenue impacts were not analyzed.

![Recommendations \& Limitations Dashboard](images/05\_recommendations\_limitations.png)



---

## How to Explore This Project

1. **Browse the README** for the business questions, methodology, findings, and limitations.
2. **Review the notebooks** to see the Python data preparation and feature engineering workflow.
3. **Open the SQL files** to review the reporting views and analytical queries used for BI reporting.
4. **Open `powerbi/Urban\_Mobility\_Intelligence.pbix`** in Power BI Desktop to explore the full interactive dashboard.



---

# Project Structure

```text
Urban_Mobility_Intelligence/
│
├── images/
│   ├── 01_overview.png
│   ├── 02_demand_geography.png
│   ├── 03_weather_impact.png
│   ├── 04_data_methodology.png
│   └── 05_recommendations_limitations.png
│
├── notebooks/
│   └── Python data preparation and analysis notebooks
│
├── sql/
│   └── SQL scripts and reporting views
│
├── powerbi/
│   └── Urban_Mobility_Intelligence.pbix
│
├── data_dictionary_trip_records_yellow.pdf
├── taxi_zone_lookup.csv
│
└── README.md
```



## What This Project Demonstrates

This project demonstrates the ability to:

* Work with large-scale real-world datasets.
* Clean and validate analytical data.
* Engineer meaningful business features.
* Load and query data using SQL Server.
* Build reporting views for BI consumption.
* Create DAX measures and comparative analysis.
* Design a multi-page Power BI dashboard.
* Translate analysis into findings while clearly communicating limitations.

---

## Author

**Harshitha Gurram**  
Aspiring Data Analyst | Python | SQL | Power BI | Excel

I come from a backend development background and am transitioning into data analytics, with a focus on building end-to-end projects that combine data preparation, SQL, analysis, and business-focused dashboards.

* **LinkedIn:** [www.linkedin.com/in/gurram-harshitha-939179277/](https://www.linkedin.com/in/gurram-harshitha-939179277/)
* **GitHub:** [github.com/gurramharshitha7](https://github.com/gurramharshitha7)

---

If you found this project interesting, feel free to explore the repository, notebooks, SQL workflow, and Power BI dashboard.

