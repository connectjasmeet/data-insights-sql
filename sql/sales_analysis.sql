--Basic Sales Analysis: Total Sales by Region

SELECT
    region,
    COUNT(order_id) AS total_orders,
    SUM(amount) AS total_sales,
    AVG(amount) AS avg_order_value
FROM
    sample_sales
GROUP BY
    region
ORDER BY
    total_sales DESC;
