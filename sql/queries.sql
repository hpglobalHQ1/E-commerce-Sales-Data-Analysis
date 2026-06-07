/*
Business purpose: Identify the highest-revenue products so the business can prioritize inventory,
merchandising, and promotion decisions around proven revenue drivers.
*/
-- Query 1: Top 10 products by total revenue
SELECT 
    product_name,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(profit / sales * 100), 2) AS avg_margin_pct
FROM orders
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;

/*
Business purpose: Track monthly revenue, profit, and margin trends to understand seasonality,
growth patterns, and periods where profitability needs investigation.
*/
-- Query 2: Monthly revenue and profit trend
SELECT
    strftime('%Y-%m', order_date) AS month,
    ROUND(SUM(sales), 2) AS monthly_revenue,
    ROUND(SUM(profit), 2) AS monthly_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM orders
GROUP BY month
ORDER BY month;

/*
Business purpose: Compare customer segments by revenue contribution, order volume, average order
value, and profitability to guide segment-specific sales and retention strategies.
*/
-- Query 3: Customer segment performance
SELECT
    customer_segment,
    COUNT(DISTINCT customer_name) AS unique_customers,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(AVG(sales), 2) AS avg_order_value,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM orders
GROUP BY customer_segment
ORDER BY total_revenue DESC;

/*
Business purpose: Surface consistently profitable states with sufficient order volume so the business
can identify strong regional markets and replicate successful pricing or operating practices.
*/
-- Query 4: Top 10 states by average profit margin
SELECT
    state,
    COUNT(order_id) AS orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(AVG(profit / sales * 100), 2) AS avg_profit_margin_pct
FROM orders
GROUP BY state
HAVING orders >= 10
ORDER BY avg_profit_margin_pct DESC
LIMIT 10;

/*
Business purpose: Identify products that lose money overall so management can review pricing,
discounting, supplier costs, or consider discontinuation.
*/
-- Query 5: Loss-making products (negative total profit)
SELECT
    product_name,
    category,
    COUNT(order_id) AS times_ordered,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
GROUP BY product_name, category
HAVING total_profit < 0
ORDER BY total_profit ASC;
