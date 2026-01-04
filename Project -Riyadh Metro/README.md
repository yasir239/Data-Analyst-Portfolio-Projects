# Riyadh Commercial Density and Metro Impact Analysis

## Analysis using Python 
<img width="2156" height="1225" alt="Screenshot 2026-01-04 030927" src="https://github.com/user-attachments/assets/118c1d1d-6b47-417d-ae83-c42f5c82f7aa" />

## Anlaysis using PowerBI
<img width="1403" height="791" alt="Screenshot 2026-01-04 022624" src="https://github.com/user-attachments/assets/a9464ead-2966-432f-a109-442de427105a" />

## Project Overview
This project implements an end-to-end (ETL) pipeline to analyze the commercial landscape of Riyadh, Saudi Arabia. The primary objective is to evaluate the correlation between the Riyadh Metro network and commercial service density across different districts.
The system automates the extraction of geospatial data using Python, transforms it into a structured format, loads it into a PostgreSQL data warehouse, and visualizes key economic insights through an interactive Power BI dashboard.


## System Architecture
The project follows a standard ETL workflow:

1. **Extraction:** Ingesting raw CSV data containing point-of-interest (POI) records.
2. **Transformation (Python/Pandas):** - Cleaning unstructured data and handling missing values.
   - Engineering geospatial features (e.g., Metro accessibility flags).
   - Aggregating granular data into district-level statistics.
3. **Loading (PostgreSQL):** Persisting the processed data into a relational database schema.
4. **Visualization (Power BI):** Connecting directly to the database to generate business intelligence reports.

## Data Source and Processing
The dataset is located in the `data/` directory of this repository (`riyadh_integrated_analysis.csv`).

### Raw Data Characteristics
Before processing, the raw data presented several challenges:
* **Granularity:** Unstructured individual commercial points without district-level aggregation.
* **Missing Data:** Significant gaps in user ratings and category classifications.
* **Lack of Context:** Absence of transportation metrics (Metro proximity).

### Applied Transformations
* **Feature Engineering:** Calculated and assigned a binary `has_metro` flag to each district based on geospatial analysis.
* **Data Cleaning:** Imputed missing values and standardized district names for consistent SQL querying.

## Technologies Used
* **Language:** Python 3.9+
* **ETL Libraries:** Pandas, NumPy
* **Database:** PostgreSQL
* **ORM & Drivers:** SQLAlchemy, Psycopg2
* **Visualization:** Microsoft Power BI
* **Version Control:** Git


## Repository Structure
```text
.
├── data/
│   └── riyadh_integrated_analysis.csv    # Source dataset
├── scripts/
│   └── etl_pipeline.py                   # Main ETL Python script
├── dashboard/
│   ├── dashboard_screenshot.png          # Visual preview of the report
│   └── Riyadh_Analysis.pbix              # Power BI project file
├── requirements.txt                      # Project dependencies
└── README.md                             # Project documentation
