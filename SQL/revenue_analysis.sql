-- =========================================
-- Revenue Analysis
-- =========================================

-- Total revenue from cleaned transactions
SELECT ROUND(SUM(line_revenue), 2) AS total_revenue
FROM public.online_retail_clean;

-- Total number of distinct orders
SELECT COUNT(DISTINCT invoice_no) AS total_orders
FROM public.online_retail_clean;

-- Total number of line items
SELECT COUNT(*) AS total_line_items
FROM public.online_retail_clean;

-- Average revenue per line item
SELECT ROUND(AVG(line_revenue), 2) AS avg_line_revenue
FROM public.online_retail_clean;


-- =========================================
-- Order-Level Metrics
-- =========================================

-- Average order value
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        invoice_no,
        SUM(line_revenue) AS order_total
    FROM public.online_retail_clean
    GROUP BY invoice_no
) t;

-- Largest orders by value
SELECT
    invoice_no,
    ROUND(SUM(line_revenue), 2) AS order_total
FROM public.online_retail_clean
GROUP BY invoice_no
ORDER BY order_total DESC
LIMIT 10;


-- =========================================
-- Monthly Revenue
-- =========================================

-- Monthly revenue trend
SELECT
    DATE_TRUNC('month', invoice_date) AS revenue_month,
    ROUND(SUM(line_revenue), 2) AS monthly_revenue
FROM public.online_retail_clean
GROUP BY 1
ORDER BY 1;

-- Monthly order counts
SELECT
    DATE_TRUNC('month', invoice_date) AS order_month,
    COUNT(DISTINCT invoice_no) AS monthly_orders
FROM public.online_retail_clean
GROUP BY 1
ORDER BY 1;

-- Monthly average order value
SELECT
    order_month,
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT
        DATE_TRUNC('month', invoice_date) AS order_month,
        invoice_no,
        SUM(line_revenue) AS order_total
    FROM public.online_retail_clean
    GROUP BY 1, 2
) t
GROUP BY order_month
ORDER BY order_month;


-- =========================================
-- Best / Worst Months
-- =========================================

-- Highest revenue month
SELECT
    DATE_TRUNC('month', invoice_date) AS revenue_month,
    ROUND(SUM(line_revenue), 2) AS monthly_revenue
FROM public.online_retail_clean
GROUP BY 1
ORDER BY monthly_revenue DESC
LIMIT 1;

-- Lowest revenue month
SELECT
    DATE_TRUNC('month', invoice_date) AS revenue_month,
    ROUND(SUM(line_revenue), 2) AS monthly_revenue
FROM public.online_retail_clean
GROUP BY 1
ORDER BY monthly_revenue ASC
LIMIT 1;