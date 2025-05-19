-- Assesment_Q1.sql
-- Identify customusers who have atleast one funded saveings plan and one funded investment plan
-- Output includes number of each plan type nd total confirmed deposits
-- Sorted by total deposit in descending order

SELECT 
u.id AS owner_id,
CONCAT(u.first_name, ' ', u.last_name) AS name,

-- Count savings plans (is_regular_savings = 1)
COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,

-- Count investment plans (is_a_fund = 1)
COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,

-- Sum of confirmed inflows per user
SUM(s.confirmed_amount) AS total_deposits
FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount s ON s.plan_id = p.id

-- Only include plans and savings that are active and funded
WHERE p.is_deleted = 0 AND s.confirmed_amount > 0
GROUP BY u.id, name

-- Include only those with at least one of each plan type
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;