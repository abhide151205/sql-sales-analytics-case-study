-- =========================================
-- Customer Analysis
-- =========================================

-- Top 10 customers by lifetime revenue
SELECT
    customer_id,
    ROUND(SUM(line_revenue), 2) AS customer_revenue
FROM public.online_retail_customer_clean
GROUP BY customer_id
ORDER BY customer_revenue DESC
LIMIT 10;

-- Top 10 customers by number of distinct orders
SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM public.online_retail_customer_clean
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- Top 10 customers by total units purchased
SELECT
    customer_id,
    SUM(quantity) AS total_units_purchased
FROM public.online_retail_customer_clean
GROUP BY customer_id
ORDER BY total_units_purchased DESC
LIMIT 10;


-- =========================================
-- Customer-Level Summary Metrics
-- =========================================

-- Average revenue per customer
SELECT ROUND(AVG(customer_revenue), 2) AS avg_revenue_per_customer
FROM (
    SELECT
        customer_id,
        SUM(line_revenue) AS customer_revenue
    FROM public.online_retail_customer_clean
    GROUP BY customer_id
) t;

-- Average number of orders per customer
SELECT ROUND(AVG(customer_orders), 2) AS avg_orders_per_customer
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS customer_orders
    FROM public.online_retail_customer_clean
    GROUP BY customer_id
) t;


-- =========================================
-- Repeat vs Single-Purchase Customers
-- =========================================

-- Number of repeat customers
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT
        customer_id
    FROM public.online_retail_customer_clean
    GROUP BY customer_id
    HAVING COUNT(DISTINCT invoice_no) > 1
) t;

-- Number of single-purchase customers
SELECT COUNT(*) AS single_purchase_customers
FROM (
    SELECT
        customer_id
    FROM public.online_retail_customer_clean
    GROUP BY customer_id
    HAVING COUNT(DISTINCT invoice_no) = 1
) t;


-- =========================================
-- High-Value Customer Segments
-- =========================================

-- Customers with revenue above overall average customer revenue
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(line_revenue) AS revenue
    FROM public.online_retail_customer_clean
    GROUP BY customer_id
),
avg_customer_revenue AS (
    SELECT AVG(revenue) AS avg_revenue
    FROM customer_revenue
)
SELECT
    cr.customer_id,
    ROUND(cr.revenue, 2) AS revenue
FROM customer_revenue cr
CROSS JOIN avg_customer_revenue a
WHERE cr.revenue > a.avg_revenue
ORDER BY cr.revenue DESC
LIMIT 20;

-- Customer lifetime value distribution summary
SELECT
    MIN(customer_revenue) AS min_customer_revenue,
    ROUND(AVG(customer_revenue), 2) AS avg_customer_revenue,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY customer_revenue) AS median_customer_revenue,
    MAX(customer_revenue) AS max_customer_revenue
FROM (
    SELECT
        customer_id,
        SUM(line_revenue) AS customer_revenue
    FROM public.online_retail_customer_clean
    GROUP BY customer_id
) t;