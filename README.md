# Walmart Strategic Retail Analytics: End-to-End Data Intelligence Pipeline
###  Python (ETL) |  MySQL (Business Logic) |  Power BI (Diagnostic Analytics)

##  Executive Summary
This project delivers a comprehensive diagnostic analysis of Walmart's retail performance across 45 stores. By integrating a full-stack data pipeline, I transformed 6,000+ raw records into a strategic decision-making suite. The analysis moves beyond descriptive reporting to identify the *"Why"* behind sales fluctuations—specifically correlating holiday seasonality and macroeconomic drivers (Unemployment, CPI, and Fuel Prices) with revenue stability.

---

##  Technical Architecture & Workflow

### 1. Data Engineering & EDA (Python)
Utilized *Pandas* and *NumPy* to architect a robust ETL process. 
* *Data Sanitization*: Engineered a cleaning script to handle missing values and enforce business constraints (e.g., filtering non-positive sales records).
* *Feature Engineering*: Extracted temporal dimensions (Year, Month, Week) and engineered a 'Holiday Lift' metric.
* *Exploratory Analysis: Leveraged **Seaborn* heatmaps to identify early-stage correlations between external market factors and sales volume.

### 2. Scalable Data Modeling (MySQL)
Migrated cleaned datasets into a relational database to execute complex business logic at scale.
* *Performance Ranking: Developed **Window Functions* (RANK() OVER) to categorize store performance dynamically.
* *Advanced Aggregations*: Crafted optimized queries to calculate 'Holiday Lift %' and regional economic exposure.
* *Reporting Layer Optimization: Developed SQL **Views* to decouple the processing layer from the visualization layer, ensuring high-performance dashboard refreshes.

### 3. Diagnostic Business Intelligence (Power BI)
Developed a 3-page interactive analytical suite designed for different organizational stakeholders:

#### *Page 1: Executive Sales Overview*
Focuses on high-level KPI tracking, monthly seasonality, and identifying the top 10 revenue-generating stores.
> Key Insight: Stores 20 and 4 are the primary revenue drivers, contributing significantly to the $6.7B total sales.

#### *Page 2: Seasonality & Holiday Analysis*
A deep dive into temporal spikes, proving that November drives a *42% Holiday Lift*, essential for inventory planning.
> Key Insight: Holiday weeks consistently outperform regular weeks, except for a notable dip in December post-peak.

#### *Page 3: Market Risk Analysis*
A sophisticated diagnostic tool correlating sales with local unemployment and inflation trends.
> Key Insight: Identified a "High Risk" threshold at **13.12% Unemployment* (Stores 12, 28, 38), where economic pressure is highest.*

---

## ⚙️ How to Reproduce
To replicate this analysis, follow these steps in order:

1. *Data Prep*: Run the Jupyter Notebook in /notebook to process the raw CSV.
2. *Database*: Execute the scripts in /sql to create the schema and views in your MySQL instance.
3. *Visualize*: Open walmart_analysis.pbix in Power BI and refresh the data source to view the dashboards.

---

## 📈 Key Business Insights
* *Macroeconomic Sensitivity: Identified a "High Risk" threshold at **8.00% Unemployment*, where store revenue begins to decouple from historical growth trends.
* *Inventory Optimization*: Data reveals that despite high CPI (Inflation), sales remain resilient in Q4, suggesting that holiday demand outweighs inflationary pressure.
* *Operational Priority*: Ranked Store 20 and Store 4 as the highest revenue contributors, while flagging Stores 12 and 28 for immediate operational review due to extreme local unemployment.
* *Dual-Axis Synchronization*: Successfully implemented a dual-axis chart in Power BI to compare currency (Total Sales) against index values (CPI) on a single visual.
* *Priority Sorting: Solved "zigzag" data display issues by creating a custom **Store Risk Rank* in DAX/SQL to sort tables by unemployment priority.

---

## 📂 Repository Structure
```text
├── data/               # Raw and processed datasets
├── notebook/           # Jupyter Notebooks for ETL & EDA
├── sql/                # SQL scripts for schema, views, and rankings
├── Image/              # Dashboard screenshots and architecture diagrams
├── walmart_analysis.pbix # Final Power BI Report
└── README.md           # Project Documentation

---

