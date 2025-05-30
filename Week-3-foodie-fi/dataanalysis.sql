--                    B. Data Analysis Questions
use foodie_fi;
-- 1.How many customers has Foodie-Fi ever had?
select count(distinct customer_id) as customers_count from subscriptions;

-- 2.What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
select month(start_date) as months,count(plan_id) as trail_plan_monthly from subscriptions
where plan_id = 0
group by month(start_date)
order by months;

-- 3.What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
select plan_id,count(*) as count_of_plan from subscriptions
where year(start_date) > 2020
group by plan_id
order by plan_id;

-- 4.What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
select sum(case when plan_id = 4 then 1 else 0 end) as total_customer_count,
round(sum(case when plan_id = 4 then 1 else 0 end) / count(distinct customer_id) * 100, 1) as customer_churned_percentage 
from subscriptions;

-- 5.How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
select count(*) as no_of_people_churned_after_trail,
round(count(*) / (select count(distinct customer_id) from subscriptions) *100,1) as percentage_of_churn 
from (select customer_id,plan_id,row_number() over(partition by customer_id) as rnk from subscriptions) x
where x.rnk = 2 and x.plan_id = 4;

-- 6.What is the number and percentage of customer plans after their initial free trial?
select plan_id,plan_name,count(cnt) as plan_count,
round(count(cnt) / (select count(distinct customer_id) from subscriptions) * 100,2) as percentage
from (select customer_id,p.*,start_date,row_number() over(partition by customer_id) as cnt 
from subscriptions s join plans p
on s.plan_id = p.plan_id) x
where x.cnt = 2
group by plan_id,plan_name
order by plan_count desc;

-- 7.What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31
with cte as 
(select customer_id,p.*,start_date,row_number() over(partition by customer_id) as cnt 
from subscriptions s join plans p
on s.plan_id = p.plan_id)
select plan_id,plan_name,count(cnt) as plan_count,
round(count(cnt) / ((select count(*) from subscriptions)) * 100,2) as percentage
from cte
where start_date <= '2020-12-31'
group by plan_id,plan_name
order by plan_count desc;

-- 8.How many customers have upgraded to an annual plan in 2020?
with cte as 
(select customer_id,p.*,start_date 
from subscriptions s join plans p
on s.plan_id = p.plan_id)
select count(distinct customer_id) as customer_count from cte
where plan_id = 3 and year(start_date) = 2020;

-- 9.How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
with annual_plan_cte as 
(select customer_id,p.*,start_date,
lag(start_date) over(partition by customer_id order by start_date) as next_day from subscriptions s join plans p
on s.plan_id = p.plan_id)
select avg(start_date-next_day) days from annual_plan_cte
where start_date is not null and next_day is not null and plan_id in (0,3)


-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)


-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
with downgraded_cte as 
(select customer_id,p.plan_id,ROW_NUMBER() over(partition by customer_id) as rn
from subscriptions s join plans p
on s.plan_id = p.plan_id)
select sum(case when plan_id = 2 and rn = 4 then 1 else 0 end) as customer_count from downgraded_cte













