select * from public."Walmart"

--drop table walmart_sales so i can change to lower case

select distinct payment_method from public."Walmart"
drop database walmart_sales_db
select payment_method,count(*) from public."Walmart"
group by payment_method

select count(distinct branch)
from public."Walmart";

select max(quantity) from public."Walmart";
select min(quantity) from public."Walmart";

--business Problems
-- Q.1 Find different payment method and number of transactions, number of qty sold

select payment_method,
	count(*) as no_payments,
	sum(quantity) as no_qty_sold
from public."Walmart"
group by payment_method

--Project question #2
-- Q.2 Identify the highest-reated category in each branch, displaying the branch, category 
-- AVG Rating
select *
from
(select branch, category, 
	avg(rating) as avg_rating,
    RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) as rank
from public."Walmart"
	group by 1, 2
	)
	where  rank = 1

--Q.3 Identify the busiest day for each branch based on the number of transactions
select * 
from
(select 
	branch,
	to_char(to_date(date, 'DD/MM/YY'),'day') as day_name,
	count(*) as no_transactions,
    RANK() OVER (PARTITION BY branch ORDER BY count(*) DESC) as rank
from public."Walmart"
group by 1,2
)
where rank = 1

--Q.4 Calculate tht total qunatity of items sold per payment method. List payment_method and total_quantity.

select payment_method,
	sum(quantity) as no_qty_sold
from public."Walmart"
group by payment_method

--Q.5 
--Determine the average, minimum, and maximum rating of category for each city. 
--List the city, average_rating, min_rating, and max_ratig.

SELECT city,category,
       AVG(rating) AS average_rating,
       MIN(rating) AS min_rating,
       MAX(rating) AS max_rating
FROM public."Walmart"
GROUP BY 1,2

--Q.6 
--Calculate the total profit for each category 
--by considering total_profit as (unit_price * quantity * profit_margin)

select category,
       sum(unit_price * quantity ) AS total_revenue,
       sum(unit_price * quantity * profit_margin) AS profit
from public."Walmart"
group by 1


--Q.7
--Determine the most common payment method for each Branch.
--Display Branch and the preferred_payment_method.

--select branch, payment_method AS pref_pay_method
--from (
--    select branch,
--           payment_method,
--           count(*) AS total_trans,
--           RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank
--    from public."Walmart"
--    group by 1, 2
--) as ranked
--WHERE rank = 1
--ORDER BY 1;

--from public."Walmart"

SELECT branch,
       payment_method AS pref_pay_method,
       total_trans,
       rank
FROM (
    SELECT branch,
           payment_method,
           COUNT(*) AS total_trans,
           RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank
    FROM public."Walmart"
    GROUP BY branch, payment_method
) AS ranked
WHERE rank = 1
ORDER BY branch;

--Q.8 
--Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
--Find out each of the shift and number of invoices

select branch, 
case 
	WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning' 
	WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon' 
	ELSE 'Evening' 
	END day_time, 
	COUNT(*) FROM public."Walmart" 
	group by 1,2 
	order by 1, 3 desc

	--Q9 
	--Identify 5 branch with highest decrese ratio in 
	--revevnue compare to last year (current year 2023 and last year 2022)
select date from public."Walmart" 
	SELECT
    curr.branch,
    curr.total_revenue AS revenue_2023,
    prev.total_revenue AS revenue_2022,
    ((curr.total_revenue - prev.total_revenue) / prev.total_revenue) * 100 AS revenue_change_pct
FROM
    (
        SELECT branch, SUM(unit_price * quantity) AS total_revenue
        FROM public."Walmart"
        WHERE EXTRACT(YEAR FROM date::date) = 2023
        GROUP BY branch
    ) AS curr
JOIN
    (
        SELECT branch, SUM(unit_price * quantity) AS total_revenue
        FROM public."Walmart"
        WHERE EXTRACT(YEAR FROM date::date) = 2022
        GROUP BY branch
    ) AS prev
ON curr.branch = prev.branch
ORDER BY revenue_change_pct desc
LIMIT 5;


SELECT
    curr.branch,
    curr.total_revenue AS revenue_2023,
    prev.total_revenue AS revenue_2022,
    ((curr.total_revenue - prev.total_revenue) / prev.total_revenue) * 100 AS revenue_change_pct
FROM
    (
        SELECT branch, SUM(unit_price * quantity) AS total_revenue
        FROM public."Walmart"
        WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
        GROUP BY branch
    ) AS curr
JOIN
    (
        SELECT branch, SUM(unit_price * quantity) AS total_revenue
        FROM public."Walmart"
        WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022
        GROUP BY branch
    ) AS prev
ON curr.branch = prev.branch
ORDER BY revenue_change_pct ASC
LIMIT 5;
