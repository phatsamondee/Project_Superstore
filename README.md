# 📊 Superstore Sales Analysis (SQL + Excel + Tableau)

## Project Overview
This project analyzes the Sample Superstore dataset using SQL, Excel, and Tableau to identify key business insights related to sales performance, profitability, customer behavior, and shipping efficiency.

The project follows a complete analytics workflow, including data cleaning, feature engineering, exploratory data analysis (EDA), business analysis, and interactive dashboard development.

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| 🛢️ DB Browser for SQLite (SQLite) | Data cleaning, feature engineering, business analysis |
| 📊 Excel (Pivot Tables) | Initial data exploration and KPI validation |
| 📈 Tableau | Interactive dashboard and data visualization |

## 🗂️ Dataset
**Dataset:** Sample Superstore Dataset

**Source:** https://www.kaggle.com/datasets/vivek468/superstore-dataset-final

### Dataset Information
- Records: 9,994
- Columns: 21
- Time Period: 2014–2017
- Country: United States

### Dataset Summary
| Category | Columns |
|----------|---------|
| Order Information | Order ID, Order Date, Ship Date, Ship Mode |
| Customer Information | Customer ID, Customer Name, Segment |
| Geographic Information | Country, Region, State, City, Postal Code |
| Product Information | Product ID, Category, Sub-Category, Product Name |
| Business Metrics | Sales, Quantity, Discount, Profit |

## Project Workflow

### 1. Data Cleaning

Performed data quality checks to ensure the dataset was accurate and ready for analysis.

1. **Checked missing values**
    - No missing values were found.

2. **Checked duplicate records**
    - Found **1 duplicate record**, which was removed.

3. **Validated postal codes**
    - Checked for postal codes with a length other than 5 digits.
    - Found 4-digit postal codes where the leading zero was dropped during data import.
    - Added leading zeros to standardize all postal codes to 5 digits.

4. **Detected encoding issues**
    - Checked customer names for encoding inconsistencies.

5. **Validated data types**
    - Converted `Postal_Code` from **INTEGER → TEXT**.
    - Converted `Discount` from **INTEGER → REAL**.
    - Note: Retained `Order_Date` and `Ship_Date` as **TEXT**, since SQLite does not enforce a native `DATE` data type.

---

### 2. Created Cleaned Dataset
Created a cleaned table named `Sample_Superstore_clean` within the SQLite database.

The cleaned database is available in the [`data/`](data/) folder.

---

### 3. Data Validation
Validated the cleaned dataset to ensure:
- No missing values
- No duplicate records
- Correct data types
- Standardized postal codes
- Clean customer names

---

### 4. Feature Engineering

Created an analytical view by adding derived features to support business analysis, including:

- Order Year, Month, and Quarter
- Shipping Delay (days)
- Discount Type
- Customer Level based on sales and purchase frequency: Platinum (Top 10%), Gold (Top 20%), Silver (Top 40%) and Classic (Others)

The generated features were validated before being used in subsequent analyses and dashboard development.

---

### 5. Exploratory Data Analysis (EDA)
Performed exploratory analysis to understand the dataset before answering business questions.

EDA included:
- 🗂️ Dataset overview
- 📆 Date range
- 💰 Sales distribution
- 📈 Profit distribution
- 🏷️ Discount distribution
- 🚚 Shipping delay distribution
- 📦 Category overview
- 🌎 Region overview

## 📊 Business Analysis
Analyzed the feature-engineered dataset to identify the key factors influencing sales and profitability.

The analysis focused on the following business questions:

1. **Overall Business Performance**
   - Total Sales
   - Total Profit
   - Profit Margin
   - Total Orders
   - Average Order Value (AOV)
   - Total Customers

2. **Product Performance**
   - Which product categories generate the highest sales and profit?

3. **Regional Performance**
   - Which regions and states perform the best?

4. **Customer Analysis**
   - Which customer segments contribute the most revenue?
   - How does customer spending vary by Customer Level (Platinum, Gold, Silver, and Classic)?

5. **Shipping Analysis**
   - Which shipping mode is used most frequently?
   - What is the average shipping delay?

6. **Sales Trends**
   - Monthly Trend
   - Quarterly Trend
   - Yearly Trend
   - Average Monthly Performance (2014–2017)

---

## 📊 Excel Analysis

Excel Pivot Tables were used for exploratory business analysis and to cross-check key metrics generated from SQL before developing the Tableau dashboard.

The analysis covered:

- KPI Summary
- Product Group Profitability
- Regional Performance
- State Performance
- Shipping Mode Analysis
- Average Shipping Delay
- Monthly Sales Trend (Top 3 Months)
- Quarterly Sales Trend
- Yearly Sales Trend

## 📈 Tableau Dashboard
The feature-engineered dataset was imported into Tableau to create an interactive dashboard for monitoring business performance and exploring key insights.

🔗 **Interactive Dashboard:** [View on Tableau Public](https://public.tableau.com/views/Dashboard_Superstore_17838516196350/Dashboard1?:language=th-TH&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

<img width="2430" height="1578" alt="Dashboard_Superstore" src="https://github.com/user-attachments/assets/e8e05e67-261d-49c1-a364-837017430e15" />

## 💡 Key Insights

- **Business Performance**
  - Generated **$2.30M** in total sales and **$286K** in total profit from **2014–2017**, resulting in a **12.47% profit margin** across **5,009 orders**.

- **Annual Performance**
  - Sales and profit increased consistently from **2014 to 2017**, with **2017** recording the highest total sales and profit. However, **profit margin declined in 2017**, indicating lower profitability relative to revenue compared with previous years.

- **Monthly Trend**
  - Total monthly sales peaked in **November** and **December**, while **February** recorded the highest profit margin.

- **Product Performance**
  - **Technology** generated the highest sales, followed by **Office Supplies** and **Furniture**.
  - **Phones** and **Chairs** were the top-performing sub-categories by sales.
  - In contrast, **Tables**, **Bookcases**, and **Supplies** generated **negative profits**, suggesting these sub-categories may require pricing, discount, or cost optimization.

- **Regional Performance**
  - The **West** region recorded the highest sales, led by **California**, followed by **New York (East)** and **Texas (Central)**.

- **Customer Analysis**
  - **Classic** customers accounted for the highest sales across all segments, with **Consumer** generating the most sales, followed by **Corporate** and **Home Office**.
  - In contrast, **Gold** and **Platinum** customers generally delivered the highest profit margins.

- **Shipping Analysis**
  - **Standard Class** was the most frequently used shipping mode.
  - Average shipping delay ranged from **0–5 days**, depending on the shipping method.
