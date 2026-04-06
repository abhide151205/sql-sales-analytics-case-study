-- =========================================
-- Product Analysis
-- =========================================

-- Top 10 products by revenue
SELECT
    stock_code,
    description,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM public.online_retail_clean
GROUP BY stock_code, description
ORDER BY total_revenue DESC
LIMIT 10;

-- Top 10 products by quantity sold
SELECT
    stock_code,
    description,
    SUM(quantity) AS total_units_sold
FROM public.online_retail_clean
GROUP BY stock_code, description
ORDER BY total_units_sold DESC
LIMIT 10;

-- Top 10 products by number of distinct orders
SELECT
    stock_code,
    description,
    COUNT(DISTINCT invoice_no) AS order_frequency
FROM public.online_retail_clean
GROUP BY stock_code, description
ORDER BY order_frequency DESC
LIMIT 10;


-- =========================================
-- Product-Level Summary Metrics
-- =========================================

-- Average revenue generated per product SKU
SELECT ROUND(AVG(product_revenue), 2) AS avg_revenue_per_product
FROM (
    SELECT
        stock_code,
        SUM(line_revenue) AS product_revenue
    FROM public.online_retail_clean
    GROUP BY stock_code
) t;

-- Average units sold per product SKU
SELECT ROUND(AVG(product_units), 2) AS avg_units_per_product
FROM (
    SELECT
        stock_code,
        SUM(quantity) AS product_units
    FROM public.online_retail_clean
    GROUP BY stock_code
) t;


-- =========================================
-- Lowest-Performing Products
-- =========================================

-- Bottom 10 products by revenue among products that appeared in at least 10 orders
SELECT
    stock_code,
    description,
    ROUND(SUM(line_revenue), 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS order_frequency
FROM public.online_retail_clean
GROUP BY stock_code, description
HAVING COUNT(DISTINCT invoice_no) >= 10
ORDER BY total_revenue ASC
LIMIT 10;

-- Bottom 10 products by quantity among products that appeared in at least 10 orders
SELECT
    stock_code,
    description,
    SUM(quantity) AS total_units_sold,
    COUNT(DISTINCT invoice_no) AS order_frequency
FROM public.online_retail_clean
GROUP BY stock_code, description
HAVING COUNT(DISTINCT invoice_no) >= 10
ORDER BY total_units_sold ASC
LIMIT 10;


-- =========================================
-- Product Price Checks
-- =========================================

-- Highest average selling price products
SELECT
    stock_code,
    description,
    ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM public.online_retail_clean
GROUP BY stock_code, description
ORDER BY avg_unit_price DESC
LIMIT 10;

-- Products with the widest price variation
SELECT
    stock_code,
    description,
    ROUND(MIN(unit_price), 2) AS min_price,
    ROUND(MAX(unit_price), 2) AS max_price,
    ROUND(MAX(unit_price) - MIN(unit_price), 2) AS price_range
FROM public.online_retail_clean
GROUP BY stock_code, description
HAVING COUNT(*) >= 5
ORDER BY price_range DESC
LIMIT 10;