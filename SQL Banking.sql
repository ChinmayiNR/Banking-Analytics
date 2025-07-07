-- 1.Total credit Amount
select sum(Amount) as Total_credit_Amount
from data.banking
where Transaction_Type='Credit';

-- 2.Total debit Amount
select sum(Amount) as total_debit_Amount
from data.banking
where Transaction_Type='Debit';

-- 3.Credit to debit Ratio
select sum(case when Transaction_Type='Credit' then Amount else 0 end)*1.0 /
nullif(sum(case when transaction_type='Debit' then Amount else 0 end),0) 
as Credit_Debit_Ratio
from data.banking;

-- 4. Net Transaction Amount
select sum(case when Transaction_Type='Credit' then Amount else 0 end) -
sum(case when transaction_type='Debit' then Amount else 0 end)
as Net_Transaction_Amount
from data.banking;

-- 5.Account Activity Ratio
select count(ID)/sum(balance) as account_Activity_Ratio
from data.banking;

-- 6.Transaction per Month
SELECT DATE_FORMAT(STR_TO_DATE(Transaction_Date, '%d-%m-%Y'), '%Y-%m') AS Month,
COUNT(*) AS Number_of_Transactions
FROM data.banking
GROUP BY DATE_FORMAT(STR_TO_DATE(Transaction_Date, '%d-%m-%Y'), '%Y-%m')
ORDER BY Month;

-- transaction per day

SELECT DATE_FORMAT(STR_TO_DATE(Transaction_Date, '%d-%m-%Y'), '%Y-%m-%d') AS Day,
COUNT(*) AS Transaction_Count
FROM data.banking
GROUP BY DATE_FORMAT(STR_TO_DATE(Transaction_Date, '%d-%m-%Y'), '%Y-%m-%d')
ORDER BY Day;

-- transaction per week
SELECT YEARWEEK(STR_TO_DATE(Transaction_Date, '%d-%m-%Y'), 1) AS YearWeek,
COUNT(*) AS Transaction_Count
FROM data.banking
GROUP BY YEARWEEK(STR_TO_DATE(Transaction_Date, '%d-%m-%Y'), 1)
ORDER BY YearWeek;


-- 7. Total Transaction Amount by Branch
select Branch,sum(Amount) as total_Amount
from data.banking
group by Branch
order by Total_Amount desc;

-- 8. Transaction Volume by Bank
select bank_name,sum(Amount) as Transaction_Volume
from data.banking
group by bank_name
order by Transaction_Volume  desc;

-- 9.Transaction method Distribution
select Transaction_Method,sum(Amount) as Total_Amount
from data.banking
group by Transaction_Method
order by Total_Amount desc;

-- 10.Branch Transaction Growth

WITH MonthlyTotals AS (SELECT Branch,DATE_FORMAT(STR_TO_DATE(Transaction_Date, '%d-%m-%Y'), '%Y-%m') AS Month,SUM(Amount) AS Total_Amount
FROM data.banking
GROUP BY Branch, DATE_FORMAT(STR_TO_DATE(Transaction_Date, '%d-%m-%Y'), '%Y-%m')),
WithGrowth AS (SELECT Branch,Month,Total_Amount,
LAG(Total_Amount) OVER (PARTITION BY Branch ORDER BY Month) AS Prev_Month_Amount
FROM MonthlyTotals)
SELECT Branch,Month,Total_Amount,Prev_Month_Amount,
ROUND(IFNULL((Total_Amount - Prev_Month_Amount) / Prev_Month_Amount * 100, 0),2) AS Percentage_Growth
FROM WithGrowth
ORDER BY Branch, Month;

-- 11.High Risk transaction Flag
select count(*) as Highrisk_Transaction_flag
from data.banking
where amount>4000;

-- 12.Suspecious Transaction Frequency
SELECT DATE_FORMAT(STR_TO_DATE(Transaction_Date, '%d-%m-%Y'), '%Y-%m') AS Month,
COUNT(*) AS High_Risk_Transaction_Count
FROM data.banking
WHERE Amount > 4000
OR Description IN ('Online Shopping', 'Refund for Overcharge', 'International Transfer')
GROUP BY DATE_FORMAT(STR_TO_DATE(Transaction_Date, '%d-%m-%Y'), '%Y-%m')
ORDER BY Month;







