-- Assessment_Q4.sql
-- Estimate Customer Lifetime Value (CLV)
-- CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
-- avg_profit_per_transaction = 0.001 * average transaction value

-- Summarize each customer's transaction activity
WITH customer_transactions AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        AVG(s.confirmed_amount) AS avg_txn_value,
        SUM(s.confirmed_amount) AS total_value
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0
    GROUP BY s.owner_id
),

-- Calculate tenure in months
user_tenure AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM users_customuser u
),

-- Combine data and compute estimated CLV
clv_calc AS (
    SELECT 
        ut.customer_id,
        ut.name,
        ut.tenure_months,
        ct.total_transactions,
        ROUND(
            (ct.total_transactions / NULLIF(ut.tenure_months, 0)) * 12 * (0.001 * ct.avg_txn_value),
            2
        ) AS estimated_clv
    FROM user_tenure ut
    JOIN customer_transactions ct ON ut.customer_id = ct.owner_id
    WHERE ut.tenure_months > 0
)

-- Final output ordered by CLV
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
