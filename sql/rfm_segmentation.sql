-- RFM Segmentation Query
-- 
-- This query performs Recency-Frequency-Monetary (RFM) analysis on customer sales data.
-- It calculates:
--   - Recency: Days since the customer's last purchase
--   - Frequency: Number of orders placed
--   - Monetary: Total amount spent
-- It assigns scores (1–3) for each dimension and classifies customers into segments:
--   - Top Customer
--   - Loyal Customer
--   - At Risk
WITH rfm AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_purchase,
        COUNT(order_id) AS frequency,
        SUM(amount) AS monetary
    FROM
        sample_sales
    GROUP BY
        customer_id
),
rfm_scores AS (
    SELECT
        customer_id,
        DATE_DIFF(CURRENT_DATE(), last_purchase, DAY) AS recency,
        frequency,
        monetary,
        CASE
            WHEN DATE_DIFF(CURRENT_DATE(), last_purchase, DAY) <= 30 THEN 3
            WHEN DATE_DIFF(CURRENT_DATE(), last_purchase, DAY) <= 60 THEN 2
            ELSE 1
        END AS recency_score,
        CASE
            WHEN frequency >= 3 THEN 3
            WHEN frequency = 2 THEN 2
            ELSE 1
        END AS frequency_score,
        CASE
            WHEN monetary >= 500 THEN 3
            WHEN monetary >= 200 THEN 2
            ELSE 1
        END AS monetary_score
    FROM rfm
)
SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    (recency_score + frequency_score + monetary_score) AS rfm_total,
    CASE
        WHEN (recency_score + frequency_score + monetary_score) >= 8 THEN 'Top Customer'
        WHEN (recency_score + frequency_score + monetary_score) >= 6 THEN 'Loyal Customer'
        ELSE 'At Risk'
    END AS segment
FROM
    rfm_scores
ORDER BY rfm_total DESC, monetary DESC;
