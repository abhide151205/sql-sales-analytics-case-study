-- =========================================
-- Window Functions
-- =========================================

-- Monthly revenue with previous month revenue and month-over-month change
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', invoice_date) AS revenue_month,
        SUM(line_revenue) AS monthly_revenue
    FROM public.online_retail_clean
    GROUP BY 1
)
SELECT
    revenue_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(LAG(monthly_revenue) OVER (ORDER BY revenue_month), 2) AS previous_month_revenue,
    ROUND(
        monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY revenue_month),
        2
    ) AS revenue_change
FROM monthly_revenue
ORDER BY revenue_month;


-- Monthly revenue with month-over-month percentage growth
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', invoice_date) AS revenue_month,
        SUM(line_revenue) AS monthly_revenue
    FROM public.online_retail_clean
    GROUP BY 1
)
SELECT
    revenue_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        100.0 * (
            monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY revenue_month)
        ) / NULLIF(LAG(monthly_revenue) OVER (ORDER BY revenue_month), 0),
        2
    ) AS pct_growth_from_previous_month
FROM monthly_revenue
ORDER BY revenue_month;


-- Cumulative monthly revenue over time
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', invoice_date) AS revenue_month,
        SUM(line_revenue) AS monthly_revenue
    FROM public.online_retail_clean
    GROUP BY 1
)
SELECT
    revenue_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY revenue_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY revenue_month;


-- Rank products by total revenue
WITH product_revenue AS (
    SELECT
        stock_code,
        description,
        SUM(line_revenue) AS total_revenue
    FROM public.online_retail_clean
    GROUP BY stock_code, description
)
SELECT
    stock_code,
    description,
    ROUND(total_revenue, 2) AS total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM product_revenue
ORDER BY revenue_rank
LIMIT 20;


-- Rank customers by revenue within each country
WITH customer_country_revenue AS (
    SELECT
        country,
        customer_id,
        SUM(line_revenue) AS total_revenue
    FROM public.online_retail_customer_clean
    GROUP BY country, customer_id
)
SELECT
    country,
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    RANK() OVER (
        PARTITION BY country
        ORDER BY total_revenue DESC
    ) AS country_revenue_rank
FROM customer_country_revenue
ORDER BY country, country_revenue_rank;


-- Row number for each customer's orders by date
WITH customer_orders AS (
    SELECT DISTINCT
        customer_id,
        invoice_no,
        invoice_date
    FROM public.online_retail_customer_clean
)
SELECT
    customer_id,
    invoice_no,
    invoice_date,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY invoice_date
    ) AS customer_order_sequence
FROM customer_orders
ORDER BY customer_id, customer_order_sequence;


-- Top 3 customers by revenue in each country
WITH customer_country_revenue AS (
    SELECT
        country,
        customer_id,
        SUM(line_revenue) AS total_revenue
    FROM public.online_retail_customer_clean
    GROUP BY country, customer_id
),
ranked_customers AS (
    SELECT
        country,
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY country
            ORDER BY total_revenue DESC
        ) AS rn
    FROM customer_country_revenue
)
SELECT
    country,
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    rn AS revenue_rank_within_country
FROM ranked_customers
WHERE rn <= 3
ORDER BY country, rn;