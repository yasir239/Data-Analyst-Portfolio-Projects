# Bank Loan Defaults and Risk

## Project Summary
This project investigates loan default risk, evaluates approval rates, and identifies indicators of bad loans to support credit decisioning and risk mitigation.

## Key Analyses
- Loan approval and rejection rate analysis
- Default rate by borrower demographics and loan attributes
- Feature analysis to identify predictors of default (income, term, balance, credit history)
- Risk segmentation and borrower profiling
- Model-ready dataset preparation and basic classification modeling (optional)

## Tools & Technologies
- Data cleaning & feature engineering: Python (pandas, scikit-learn)
- Exploratory analysis: matplotlib, seaborn
- SQL for cohort extraction and summary metrics
- Optional: basic logistic regression / tree-based models for risk scoring

## Data
Example file: `Loan_default - before cleaning.csv`

## How to Use
1. Clean and preprocess loan data (missing values, outliers, encoding).
2. Perform EDA to identify strong correlates of default.
3. Build and validate a simple risk model; evaluate with ROC/AUC and confusion matrix.

## Notes
- Emphasize model interpretability and regulatory considerations when deploying credit risk models.
