### DataAnalytics-Assessment  

This repository contains my solutions to the SQL Proficiency Assessment designed to evaluate SQL querying, data analysis, and business problem-solving skills. It includes four tasks covering data retrieval, joins, aggregation, subqueries, and business logic interpretation.    
  
# Repository Structure:  
**DataAnalytics-Assessment/**  
│  
├── Assessment_Q1.sql  -- High-Value Customers with Multiple Products    
├── Assessment_Q2.sql  -- Transaction Frequency Analysis    
├── Assessment_Q3.sql  -- Account Inactivity Alert    
├── Assessment_Q4.sql  -- Customer Lifetime Value (CLV) Estimation    
└── README.md          -- Approach explanations and challenges    
  
# Question and Explanations  
**Q1:** High-Value Customers with Multiple Products  
Objective: Identify users who have at least one funded savings plan and one funded investment plan, and sort them by total confirmed deposits.  
Approach:  
•	Used conditional aggregation to count plan types.  
•	Joined the plans_plan and savings_savingsaccount tables.  
•	Filtered for active (not deleted) plans and positive confirmed_amount.  
•	Grouped by user and sorted by total deposits.  
  
**Q2:** Transaction Frequency Analysis  
Objective: Categorize customers based on the average number of transactions per month.  
Approach:  
•	Calculated total transactions and active months per user.  
•	Divided transactions by active months to compute frequency.  
•	Used CASE statements to classify users as "High", "Medium", or "Low Frequency".  
•	Grouped results and calculated the average per category.  
  
**Q3:** Account Inactivity Alert  
Objective: Find all active savings or investment plans that haven’t had any inflow in the past 365 days.  
Approach:  
•	Filtered for is_regular_savings = 1 or is_a_fund = 1 to define relevant plan types.  
•	Found each plan’s last inflow transaction date from savings_savingsaccount.  
•	Used DATEDIFF() to compute inactivity in days.  
•	Returned plans with inactivity > 365 days or with no transaction history.  
  
**Q4:** Customer Lifetime Value (CLV) Estimation  
Objective: Estimate CLV using the formula:  
CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction  
Approach:  
•	Tenure was computed using TIMESTAMPDIFF from users_customuser.date_joined.  
•	Aggregated transaction volume and average value per customer.  
•	Profit per transaction assumed as 0.1% (0.001 multiplier).  
•	Avoided division by zero using NULLIF().  
  
⚠️ **Challenges & How I Resolved Them**  
**Challenge	Resolution**  
Determining transaction frequency over variable time spans	Used TIMESTAMPDIFF() on transaction date range to normalize to monthly frequency  
Avoiding divide-by-zero in tenure calculations	Applied NULLIF() to protect against zero-month tenures  
Mapping plan types accurately	Cross-checked flags: is_regular_savings and is_a_fund  
Correct handling of inactive accounts	Treated NULL last_transaction_date as inactive  
  
🛠️ **Tools Used**  
•	MySQL  
•	Subqueries, CASE, WITH clauses (CTEs), conditional aggregation  
•	Built-in date functions like TIMESTAMPDIFF() and DATEDIFF()  
