-- Revenue by country
SELECT
    country,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM public.online_retail_clean
GROUP BY country
ORDER BY total_revenue DESC;

-- Distinct order count by country
SELECT
    country,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM public.online_retail_clean
GROUP BY country
ORDER BY total_orders DESC;

-- Distinct customer count by country
SELECT
    country,
    COUNT(DISTINCT customer_id) AS total_customers
FROM public.online_retail_customer_clean
GROUP BY country
ORDER BY total_customers DESC;


-- =========================================
-- Average Order Value by Country
-- =========================================

SELECT
    country,
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT
        country,
        invoice_no,
        SUM(line_revenue) AS order_total
    FROM public.online_retail_clean
    GROUP BY country, invoice_no
) t
GROUP BY country
ORDER BY avg_order_value DESC;


-- =========================================
-- Revenue per Customer by Country
-- =========================================

SELECT
    country,
    ROUND(AVG(customer_revenue), 2) AS avg_customer_revenue
FROM (
    SELECT
        country,
        customer_id,
        SUM(line_revenue) AS customer_revenue
    FROM public.online_retail_customer_clean
    GROUP BY country, customer_id
) t
GROUP BY country
ORDER BY avg_customer_revenue DESC;


-- =========================================
-- Top Countries by Multiple Metrics
-- =========================================

-- Top 10 countries by revenue
SELECT
    country,
    ROUND(SUM(line_revenue), 2) AS total_revenue
FROM public.online_retail_clean
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

-- Top 10 countries by order count
SELECT
    country,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM public.online_retail_clean
GROUP BY country
ORDER BY total_orders DESC
LIMIT 10;

-- Top 10 countries by customer count
SELECT
    country,
    COUNT(DISTINCT customer_id) AS total_customers
FROM public.online_retail_customer_clean
GROUP BY country
ORDER BY total_customers DESC
LIMIT 10;