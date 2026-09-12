# Retail Sales Analytics — End-to-End Data Analytics Project

An end-to-end data analytics project covering the full pipeline: **data cleaning (Python) → database storage (MySQL) → business analysis (SQL) → interactive dashboard (Power BI)**.

---

##  Tech Stack
 **Python** (pandas, SQLAlchemy) — data cleaning, feature engineering, and loading data into MySQL
 **MySQL** — data storage & SQL analysis (window functions, CTEs)
**Power BI** — interactive dashboard & DAX measures

---

##  Project Structure
retail-sales-analytics/
 superstore_sales_data.csv     # Raw dataset
 data_cleaning.py               # Python script: cleaning + MySQL load
 sql_queries.sql                # Business analysis SQL queries
 dashboard_screenshot.png       # Power BI dashboard preview
  README.md

> **Note:** `data_cleaning.py` connects to MySQL using a placeholder password (`YOUR_PASSWORD_HERE`). Replace it with your own local MySQL credentials before running.

---

##  Data Cleaning (Python)
- Removed duplicate rows
- Converted date columns to proper `datetime` format
- Fixed inconsistent text casing (e.g., "EAST" → "East")
- Handled missing values:
  - `Customer Name` filled using matching `Customer ID` from other orders
  - `Ship Mode` filled using the column's most frequent value (mode)
- Verified `Order ID` uniqueness and ran data sanity checks (no negative sales/quantity)
- Engineered new features: `order_year`, `order_month`, `delivery_days`, `profit_margin_pct`
- Standardized all column names to `snake_case`

---

##  Database (MySQL)
Cleaned data was loaded directly from Python into MySQL using **SQLAlchemy** (with PyMySQL as the underlying driver):
```python
from sqlalchemy import create_engine

engine = create_engine('mysql+pymysql://root:YOUR_PASSWORD_HERE@localhost:3306/superstore_db')
df.to_sql('sales', con=engine, if_exists='replace', index=False)
```

---

##  SQL Analysis Highlights
| Query | Purpose |
|---|---|
| Impact of Discount on Profit Margin | Shows margin turns negative above ~20% discount |
| Top Performing Regions by Total Sales | Uses `RANK() OVER()` window function |
| Cumulative Sales Trend Over Time | Running total using window functions |
| Best Customer in Each Region | Uses a CTE + `RANK() OVER (PARTITION BY region ...)` |

Full queries available in [`sql_queries.sql`](./sql_queries.sql).

---

##  Power BI Dashboard
Interactive dashboard including:
- KPI cards: Total Revenue, Profit, Total Orders, Profit Margin (DAX measure)
- State-level filled map
- Region & Category slicers
- Sales & Profit by Category, Region, Ship Mode, Segment, and Product
- Monthly Sales/Profit trends (Year-over-Year comparison)
- Discount Impact on Profit Margin chart

![Dashboard Screenshot](./dashboard_screenshot.png)

---

##  Key Business Insight
Profit margin drops sharply as discount increases. Orders with discounts above ~20% show a **negative average profit margin**, suggesting the discount policy needs to be revisited — especially for high-discount, high-volume categories.

---

##  How to Run
1. Clone this repo
2. Install dependencies: `pip install pandas sqlalchemy pymysql`
3. Create a MySQL database named `superstore_db`
4. Open `data_cleaning.py` and replace `YOUR_PASSWORD_HERE` with your own MySQL password
5. Run `data_cleaning.py` to clean the data and load it into MySQL
6. Run the queries in `sql_queries.sql` in your MySQL client
7. Open the Power BI file and connect it to your local MySQL database

---

##  Author
Built as a portfolio project to demonstrate end-to-end data analytics skills across Python, SQL, and Power BI.
