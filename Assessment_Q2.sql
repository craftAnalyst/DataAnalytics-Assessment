-- Assessment_Q2.sql
-- Analyze user transaction activity and group them into frequency categories
-- High Frequency: ≥10/month, Medium: 3-9/month, Low: ≤2/month

-- Count total transactions and calculate active months per user
WITH transaction_counts AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS tenure_months
    FROM savings_savingsaccount s
    WHERE s.transaction_date IS NOT NULL
    GROUP BY s.owner_id
),

-- Classify users by frequency
frequency_classification AS (
    SELECT 
        t.owner_id,
        (t.total_transactions / t.tenure_months) AS avg_txn_per_month,
        CASE
            WHEN (t.total_transactions / t.tenure_months) >= 10 THEN 'High Frequency'
            WHEN (t.total_transactions / t.tenure_months) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM transaction_counts t
)

-- Aggregate by category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM frequency_classification
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
