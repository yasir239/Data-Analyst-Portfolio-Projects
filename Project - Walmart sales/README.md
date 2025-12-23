# Walmart Retail Sales

## Project Summary
This project analyzes Walmart sales data to support retail forecasting, compare store performance, and identify seasonal trends affecting revenue and inventory planning.

## Key Analyses
- Time series analysis and forecasting of sales (store and SKU level)
- Store performance benchmarking and peer-group comparisons
- Seasonal trend detection (weekly, monthly, holiday effects)
- Promotion impact and uplift analysis
- Inventory and replenishment recommendations based on demand forecasts

## Tools & Technologies
- Forecasting: Python (statsmodels, Prophet) or Excel time-series models
- Data wrangling: Python (pandas) / SQL
- Dashboarding: Power BI / Tableau for executive reporting

## Data
Files: `Walmart.csv`, `walmart_cleaned.csv`, `walmart.sql`

## How to Use
1. Load cleaned sales data (`walmart_cleaned.csv`) into your environment.
2. Fit baseline forecasting models and evaluate using holdout periods.
3. Build dashboards to compare stores and visualize seasonal patterns.

## Notes
- Next steps: incorporate external signals (promotions, holidays) and tune models per store for better accuracy.
