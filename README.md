# **SQL Sales Analytics Case Study**

## **Overview**
This project analyzes retail transaction data in PostgreSQL to answer common business questions about revenue, products, customers, and country-level performance.

The project uses the **Online Retail** dataset and follows a realistic SQL analytics workflow:
- import raw transactional data into PostgreSQL
- validate and clean the raw records
- construct cleaned analysis tables
- answer business questions using SQL
- use window functions for trend and ranking analysis

This project was designed as an internship/entry-level data analyst portfolio piece, with a focus on practical SQL, structured business analysis, and clear documentation.



## **Objectives**
The goals of this project were to:

- build a PostgreSQL-based workflow for transactional retail data
- clean and prepare raw transaction records for analysis
- calculate core business KPIs such as revenue and order value
- analyze product, customer, and country performance
- demonstrate more advanced SQL using CTEs and window functions



## **Tools Used**
- PostgreSQL
- pgAdmin 4
- SQL
- Excel / CSV preprocessing
- Optional preprocessing using Python/pandas for file conversion (Excel file conversion had issues, python was used to make a cleaner conversion)



## **Dataset**
The project uses the **Online Retail** dataset, which contains transactional records including:

- invoice number
- stock code
- product description
- quantity
- invoice date
- unit price
- customer ID
- country

The source file was originally provided as an Excel spreadsheet and was converted to CSV for PostgreSQL import.



## **Datebase Workflow**
1. Raw text staging: Raw file was loaded into a text-based staging table to circumvent type-conversion failures during import.
2. Typed raw table: Staging table -> typed transactional table with integer quantities, timestamp invoices and nummeric unit prices.
3. Clean analysis table: Created by excluding cancelled invoices, non-positive quantities and non-positive prices.
4. Customer-clean table: Seperate customer-focused table created by removing rows with missing customer IDs, which allows cleaner customer-level analysis.



## **Data Cleaning Summary**
The following was found:
135,080 rows with missing customer IDs
10,624 rows with non-positive quantities
2,521 rows with non-positive unit prices
9,288 cancelled invoice rows
The cleaned analysis table excluded cancelled and non-positive values records. Rows with missing customer IDs were kept for general sales and product analysis, excluded from customer analysis.



## **SQL techniques demonstrated**
This project uses:
SELECT, WHERE, ORDERBY
GROUP BY, HAVING
COUNT, SUM, AVG,
JOIN
WITH
LAG(), RANK(), ROW_NUMBER, SUM() OVER... (cumulative totals)



## **Key Findings**
Revenue and Orders: Cleaned dataset contained 19,960 distinct completed orders. Total cleaned revenue was 10,666,684.54. Average revenue per line item was 20.12. Average order value was 534.40.
Revenue Trends: Highly uneven across the year. Highest revenue occured in November 2011 (1,509,496.33). Lowest occured in Februrary 2011 (523,631.89). Strong revenue growth observed in September 2011 and November 2011 (potentially strong late-year seasonality)
Customer Insights: Average customer revenue was 2,054.27 and median was 674.49, suggesting a highly skewed revenue distribution. 2,845 repeat customers + 1,493 single purchase customers. Customers had place an average of 4.27 orders. A small set of customers contributed a disproportionately high revenue, top customer generated 280,206.02
Product Insights: Top revenue-generating SKUs included both conventional retail products and service-related stock codes. High-performing conventional products included Party Bunting, Jumbo Bag Red Retrospot and Regency Cakestand 3 Tier. Several products performed strongly across multiple measures like revenue, units sold and order frequency.
Country Insights: UK was the dominant part in total revenue, order volume and customer count. Top countries excluding the UK by revenue included the Netherlands, Germany and France. Some smaller markets had much higher average order values than the UK such as Singapore. 



## **Important Analytical Caveats**
There were a few dataset-specific issues one has to keep in mind when interpreting the result:
Some high-revenue stock codes represented fees, postages etc. rather than actual standard retail products.
December 2011 appears materially lower than November 2011, could be however due to an incomplete month coverage in the source data.
Country-level averages for small countries should be viewed with caution as they were derived from very few customers/orders.



## **Example Questions Answered**
How much revenue did the business generate?
How did revenue change month by month?
Which products generated the most revenue?
Which customers were the most valuable?
How concentrated was customer revenue?
Which countries generated the most revenue and highest average order values?
How can window functions be used to calculate monthly growth and rank performance?



## **How to run the project**
1. Create the tables (run schema.sql)
2. Run the analysis files in order (setup_and_cleaning, revenue_analysis, product_analysis, customer_analysis, country_analysis, window_functions)
3. Review the outputs.



## **Relevance to Portfolio**
The project demonstrates skills commonly expected in entry-level data analyst roles such as:
SQL querying.
Relation data handling.
Data cleaning and preparation.
KPI analysis.
Customer and product segmentation.
Business-focused interpretation.
Usage of advanced SQL features like window functions.
