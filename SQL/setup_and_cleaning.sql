-- =========================================
-- Setup and Cleaning Checks
-- =========================================

-- Row count in raw text staging table
SELECT COUNT(*) AS raw_text_rows
FROM public.online_retail_raw_text;

-- Row count in typed raw table
SELECT COUNT(*) AS raw_typed_rows
FROM public.online_retail_raw;

-- Row count in cleaned sales table
SELECT COUNT(*) AS clean_rows
FROM public.online_retail_clean;

-- Row count in customer-clean table
SELECT COUNT(*) AS customer_clean_rows
FROM public.online_retail_customer_clean;


-- =========================================
-- Missing Value Checks
-- =========================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE invoice_no IS NULL OR invoice_no = '') AS missing_invoice_no,
    COUNT(*) FILTER (WHERE stock_code IS NULL OR stock_code = '') AS missing_stock_code,
    COUNT(*) FILTER (WHERE description IS NULL OR description = '') AS missing_description,
    COUNT(*) FILTER (WHERE quantity IS NULL OR quantity = '') AS missing_quantity,
    COUNT(*) FILTER (WHERE invoice_date IS NULL OR invoice_date = '') AS missing_invoice_date,
    COUNT(*) FILTER (WHERE unit_price IS NULL OR unit_price = '') AS missing_unit_price,
    COUNT(*) FILTER (WHERE customer_id IS NULL OR customer_id = '') AS missing_customer_id,
    COUNT(*) FILTER (WHERE country IS NULL OR country = '') AS missing_country
FROM public.online_retail_raw_text;


-- =========================================
-- Raw Data Quality Checks
-- =========================================

-- Rows with missing customer IDs in typed raw table
SELECT COUNT(*) AS missing_customer_id_rows
FROM public.online_retail_raw
WHERE customer_id IS NULL;

-- Rows with non-positive quantities
SELECT COUNT(*) AS non_positive_quantity_rows
FROM public.online_retail_raw
WHERE quantity <= 0;

-- Rows with non-positive unit prices
SELECT COUNT(*) AS non_positive_price_rows
FROM public.online_retail_raw
WHERE unit_price <= 0;

-- Cancelled invoices (invoice numbers beginning with 'C')
SELECT COUNT(*) AS cancelled_invoice_rows
FROM public.online_retail_raw
WHERE invoice_no LIKE 'C%';

-- Distinct cancelled invoice numbers
SELECT COUNT(DISTINCT invoice_no) AS distinct_cancelled_invoices
FROM public.online_retail_raw
WHERE invoice_no LIKE 'C%';


-- =========================================
-- Before / After Cleaning Comparison
-- =========================================

SELECT
    (SELECT COUNT(*) FROM public.online_retail_raw) AS raw_rows,
    (SELECT COUNT(*) FROM public.online_retail_clean) AS clean_rows,
    (SELECT COUNT(*) FROM public.online_retail_customer_clean) AS customer_clean_rows;

-- Share of rows removed by main cleaning filters
SELECT
    COUNT(*) AS raw_rows,
    COUNT(*) FILTER (
        WHERE quantity > 0
          AND unit_price > 0
          AND invoice_no NOT LIKE 'C%'
    ) AS rows_retained_in_clean_table
FROM public.online_retail_raw;


-- =========================================
-- Quick Validation Samples
-- =========================================

SELECT *
FROM public.online_retail_raw
LIMIT 10;

SELECT *
FROM public.online_retail_clean
LIMIT 10;

SELECT *
FROM public.online_retail_customer_clean
LIMIT 10;