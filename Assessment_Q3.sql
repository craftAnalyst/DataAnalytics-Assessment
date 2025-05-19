-- Assessment_Q3.sql
-- Identify plans with no inflow (confirmed deposit) in the last 365 days
-- Apply to savings (is_regular_savings = 1) and investment (is_a_fund = 1) plans

-- Get the last inflow transaction date for each plan
WITH last_transactions AS (
    SELECT 
        s.plan_id,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0
    GROUP BY s.plan_id
),

-- Identify savings and investment plan types
plan_types AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type
    FROM plans_plan p
    WHERE p.is_deleted = 0 AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
),

-- Join plan with transaction and calculate inactivity
combined AS (
    SELECT 
        pt.plan_id,
        pt.owner_id,
        pt.type,
        lt.last_transaction_date,
        DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
    FROM plan_types pt
    LEFT JOIN last_transactions lt ON pt.plan_id = lt.plan_id
)

-- Filter inactive accounts (over 365 days or never transacted)
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM combined
WHERE last_transaction_date IS NULL OR inactivity_days > 365
ORDER BY inactivity_days DESC;
