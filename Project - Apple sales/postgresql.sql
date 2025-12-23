-- chicking the types for the columns
SELECT 
    table_name, 
    column_name, 
    data_type 
FROM 
    information_schema.columns 
WHERE 
    table_schema = 'public'
ORDER BY 
    table_name;

--changing columns to the correct types
-- 1. الفئات (Category)
ALTER TABLE category 
    ALTER COLUMN category_id TYPE VARCHAR(50),
    ALTER COLUMN category_name TYPE VARCHAR(100);

-- 2. المنتجات (Products) - السعر FLOAT كما طلبت
ALTER TABLE products 
    ALTER COLUMN product_id TYPE VARCHAR(50),
    ALTER COLUMN product_name TYPE VARCHAR(200),
    ALTER COLUMN category_id TYPE VARCHAR(50),
    ALTER COLUMN price TYPE FLOAT,
    ALTER COLUMN launch_date TYPE DATE;

-- 3. المتاجر (Stores)
ALTER TABLE stores 
    ALTER COLUMN store_id TYPE VARCHAR(50),
    ALTER COLUMN store_name TYPE VARCHAR(100),
    ALTER COLUMN city TYPE VARCHAR(50),
    ALTER COLUMN country TYPE VARCHAR(50);

-- 4. المبيعات (Sales)
ALTER TABLE sales 
    ALTER COLUMN sale_id TYPE VARCHAR(50),
    ALTER COLUMN product_id TYPE VARCHAR(50),
    ALTER COLUMN store_id TYPE VARCHAR(50),
    ALTER COLUMN sale_date TYPE DATE,
    ALTER COLUMN quantity TYPE INTEGER;

-- 5. الضمان (Warranty)
ALTER TABLE warranty 
    ALTER COLUMN claim_id TYPE VARCHAR(50),
    ALTER COLUMN sale_id TYPE VARCHAR(50),
    ALTER COLUMN repair_status TYPE VARCHAR(50),
    ALTER COLUMN claim_date TYPE DATE;

select * from category
select * from products
select * from stores
select * from sales
select * from warranty


--EDA
select distinct repair_status from warranty
select count(*) from sales

--improving query performnce
-- pt - 0.11.ms
-- et -  107.ms 
-- et after index 15-11 ms
explain analyze
select * from sales
where product_id ='P-44'

create index sales_product_id on sales(product_id)
create index sales_store_id on sales(store_id)
create index sales_store_date on sales(sale_date)

explain analyze
select * from sales
where store_id ='ST-31'

-- ed 110.ms
-- ed after index 15ms


--Business Problems
-- Medium problems
-- 1. Find the number of stores in each county .
select country,
	count(store_id)
from stores
group by 1
order by 2 desc

--Q.2 Calculate the total number of units sold by each store.

select
	s.store_id,
	st.store_name,
	sum(s.quantity) as total_unit_sold
from sales as s 
join
stores as st
on st.store_id = s.store_id
group by 1,2
order by 3 desc

-- Q.3 Identify how many sales occurred in December 2023.

select 
--	*,
--	to_char(sale_date, 'MM-YYYY')
	count(sale_id) as total_sale
from sales 
where to_char(sale_date, 'MM-YYYY') = '12-2023'

-- Q.4 Determine how many stores have never had a warranty claim filed
select * from stores
select * from warranty
select * from sales
select * from products
select * from category

-- Q.4 Determine how many stores have never had a warranty claim filed

SELECT COUNT(*) FROM stores
WHERE store_id NOT IN (
    -- القائمة السوداء: المتاجر التي سجلت مطالبات ضمان
    SELECT DISTINCT store_id
    FROM sales as s
    right JOIN warranty as w 
    ON s.sale_id = w.sale_id
);

-- Q.5 Calculate the percentage of warranty claims marked as 'warranty void'.
select 
	round
		(count(claim_id)/
							(select count(*) from warranty)::numeric
		* 100,
	2)as warranty_void_percentage 
from warranty 
where repair_status = 'warranty void'

-- Q.6 Identify which store had the highest total units sold in the last year.
-- Q.6 Identify which store had the highest total units sold in the last year.

SELECT 
    s.store_id,
    st.store_name,
    SUM(s.quantity) as total_units_sold
FROM 
    sales as s
JOIN 
    stores as st ON s.store_id = st.store_id
WHERE 
    -- التصحيح 1: نعتمد على آخر تاريخ في البيانات وليس تاريخ اليوم
    sale_date >= (SELECT MAX(sale_date) - INTERVAL '1 year' FROM sales)
GROUP BY 1, 2
-- التصحيح 2: نرتب حسب المبيعات (العمود 3) وليس الاسم
ORDER BY 3 DESC
LIMIT 1;

-- Q.7 count the number of unique products sold in the last year.

SELECT 
    COUNT(DISTINCT product_id) as unique_products_sold
FROM 
    sales
WHERE 
    -- نستخدم نفس منطق الزمن الديناميكي لضمان وجود بيانات
    sale_date >= (SELECT MAX(sale_date) - INTERVAL '1 year' FROM sales);

	-- Q.8 Find the average price of products in each category.
SELECT 
    c.category_id,
    c.category_name,
    AVG(p.price) as average_price
FROM 
    products as p
JOIN 
    category as c ON p.category_id = c.category_id
GROUP BY 
    c.category_id, c.category_name
ORDER BY 
    average_price DESC;

-- Q.9 How many warranty claims were filed in 2024?

SELECT 
    COUNT(*) as warranty_claims_2024
FROM warranty
WHERE EXTRACT(YEAR FROM claim_date) = 2024;

-- Q.10 For each store, identify the best-seeling day based on highest quantity sold.
-- store_id, day_name, sum(qty)
-- window dense rank 

SELECT 
    st.store_name,
    t1.day_name,
    t1.total_quantity_sold
	t1.rnk
FROM ( SELECT store_id,
-- تحويل التاريخ إلى اسم يوم (Monday, Tuesday...)
TO_CHAR(sale_date, 'Day') as day_name,
SUM(quantity) as total_quantity_sold,
 -- الدالة السحرية: رتب الأيام من 1 إلى 7 لكل متجر بناء على المبيعات
RANK() OVER(PARTITION BY store_id ORDER BY SUM(quantity) DESC) as rnk
FROM sales
GROUP BY store_id, TO_CHAR(sale_date, 'Day')
    ) as t1
JOIN stores as st ON t1.store_id = st.store_id
WHERE t1.rnk = 1;


SELECT 
    st.store_name,
    t1.day_name,
    t1.total_quantity_sold,
    t1.rnk  -- هنا أضفنا العمود لتراه بنفسك
FROM (SELECT 
	store_id,
TO_CHAR(sale_date, 'Day') as day_name,
SUM(quantity) as total_quantity_sold,
RANK() OVER(PARTITION BY store_id ORDER BY SUM(quantity) DESC) as rnk
        FROM sales
GROUP BY store_id, TO_CHAR(sale_date, 'Day')) as t1
JOIN stores as st ON t1.store_id = st.store_id
WHERE t1.rnk = 1;

-- Medium to hard questions
-- Identify the least selling product in each country for each year based on total units sold.

SELECT t1.country, t1.report_year, t1.product_name, t1.total_units_sold, t1.rnk
FROM (
    SELECT st.country, p.product_name, EXTRACT(YEAR FROM s.sale_date) as report_year,
           SUM(s.quantity) as total_units_sold,
           RANK() OVER(PARTITION BY st.country, EXTRACT(YEAR FROM s.sale_date) ORDER BY SUM(s.quantity) ASC) as rnk
    FROM sales as s
    JOIN stores as st ON s.store_id = st.store_id
    JOIN products as p ON s.product_id = p.product_id
    GROUP BY st.country, p.product_name, EXTRACT(YEAR FROM s.sale_date)
) as t1
WHERE t1.rnk = 1
ORDER BY t1.country, t1.report_year;


WITH Sales_Ranked AS (
    SELECT 
        st.country,
        p.product_name,
        SUM(s.quantity) as total_qty,
        RANK() OVER(PARTITION BY st.country, EXTRACT(YEAR FROM s.sale_date) ORDER BY SUM(s.quantity) ASC) as rnk
    FROM sales s
    JOIN stores st ON s.store_id = st.store_id
    JOIN products p ON s.product_id = p.product_id
    GROUP BY st.country, p.product_name, EXTRACT(YEAR FROM s.sale_date)
)

SELECT country, product_name, total_qty, rnk
FROM Sales_Ranked
WHERE rnk = 1
ORDER BY country;

-- Q.12 Calculate how many warranty claims were filed within 180 days of a product sale.

SELECT COUNT(*)
FROM warranty as w
JOIN sales as s ON w.sale_id = s.sale_id
WHERE (w.claim_date - s.sale_date) <= 180;

-- Q.13 Determine how many warranty claims were filed for products launched in the last two years.

SELECT p.product_name, p.launch_date, COUNT(*) as claim_count
FROM warranty w
JOIN sales s ON w.sale_id = s.sale_id
JOIN products p ON s.product_id = p.product_id
WHERE p.launch_date >= (SELECT MAX(sale_date) - INTERVAL '2 years' FROM sales)
GROUP BY p.product_name, p.launch_date
ORDER BY claim_count DESC;

-- Q.14 List the months in the last three years where sales exceded 5,000 units in the USA.

SELECT TO_CHAR(sale_date, 'Month-YYYY') as sale_month, SUM(quantity) as total_units
FROM sales s
JOIN stores st ON s.store_id = st.store_id
WHERE st.country = 'United States'
  AND s.sale_date >= (SELECT MAX(sale_date) - INTERVAL '3 years' FROM sales)
GROUP BY DATE_TRUNC('month', sale_date), TO_CHAR(sale_date, 'Month-YYYY')
HAVING SUM(quantity) > 5000
ORDER BY DATE_TRUNC('month', sale_date);

--Q.15 Identify the products  category with the most warranty claims filed in the last two years.

SELECT c.category_name, COUNT(*) as total_claims
FROM warranty w
JOIN sales s ON w.sale_id = s.sale_id
JOIN products p ON s.product_id = p.product_id
JOIN category c ON p.category_id = c.category_id
WHERE w.claim_date >= (SELECT MAX(claim_date) - INTERVAL '2 years' FROM warranty)
GROUP BY 1
ORDER BY total_claims DESC
LIMIT 1;