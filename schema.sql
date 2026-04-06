-- =========================================
-- Creation of tables
-- =========================================

-- Creation of online_retail_clean
DROP TABLE IF EXISTS public.online_retail_clean;

CREATE TABLE public.online_retail_clean AS
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    quantity * unit_price AS line_revenue
FROM public.online_retail_raw
WHERE quantity > 0
  AND unit_price > 0
  AND invoice_no NOT LIKE 'C%';

-- Creation of online_retail_raw
DROP TABLE IF EXISTS public.online_retail_raw;

CREATE TABLE public.online_retail_raw AS
SELECT
    NULLIF(invoice_no, '') AS invoice_no,
    NULLIF(stock_code, '') AS stock_code,
    NULLIF(description, '') AS description,
    CAST(NULLIF(quantity, '') AS INTEGER) AS quantity,
    CAST(NULLIF(invoice_date, '') AS TIMESTAMP) AS invoice_date,
    CAST(NULLIF(unit_price, '') AS NUMERIC(10,2)) AS unit_price,
    NULLIF(customer_id, '') AS customer_id,
    NULLIF(country, '') AS country
FROM public.online_retail_raw_text;

-- Creation of online_retail_raw_text
DROP TABLE IF EXISTS public.online_retail_raw_text;

CREATE TABLE public.online_retail_raw_text (
    invoice_no   TEXT,
    stock_code   TEXT,
    description  TEXT,
    quantity     TEXT,
    invoice_date TEXT,
    unit_price   TEXT,
    customer_id  TEXT,
    country      TEXT
);

-- Creation of online_retail_customer_clean
DROP TABLE IF EXISTS public.online_retail_customer_clean;

CREATE TABLE public.online_retail_customer_clean AS
SELECT *
FROM public.online_retail_clean
WHERE customer_id IS NOT NULL;