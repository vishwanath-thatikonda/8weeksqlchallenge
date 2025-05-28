--                    B. Data Analysis Questions

-- How many customers has Foodie-Fi ever had?
select count(distinct customer_id) as customers_count from subscriptions;

-- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
select month(start_date) as months,count(plan_id) as trail_plan_monthly from subscriptions
where plan_id = 0
group by month(start_date)
order by months;

-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
select plan_id,count(*) as count_of_plan from subscriptions
where year(start_date) > 2020
group by plan_id
order by plan_id;

-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
select sum(case when plan_id = 4 then 1 else 0 end) as total_customer_count,
round(sum(case when plan_id = 4 then 1 else 0 end) / count(distinct customer_id) * 100, 1) as customer_churned_percentage 
from subscriptions;

-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
select count(*) as no_of_people_churned_after_trail,
round(count(*) / (select count(distinct customer_id) from subscriptions) *100,1) as percentage_of_churn 
from (select customer_id,plan_id,row_number() over(partition by customer_id) as rnk from subscriptions) x
where x.rnk = 2 and x.plan_id = 4;

-- What is the number and percentage of customer plans after their initial free trial?
select plan_id,plan_name,count(*) as c from (
select customer_id,s.plan_id,plan_name,row_number() over(partition by customer_id) as rnk from subscriptions s join plans p
on s.plan_id = p.plan_id) x
where x.plan_id <> 0
group by plan_id,plan_name -- not completed




