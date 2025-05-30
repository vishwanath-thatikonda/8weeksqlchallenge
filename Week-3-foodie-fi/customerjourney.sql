--                                                A. Customer Journey
-- Based off the 8 sample customers provided in the sample from the subscriptions table, 
-- write a brief description about each customer’s onboarding journey.

-- Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!
use foodie_fi;

-- creating a view
create view customers_view as (
select customer_id,p.*,start_date  from plans p join subscriptions s
on p.plan_id = s.plan_id);

-- selecting a view
select * from customers_view limit 5;

-- total plan count in table
select plan_name,count(*) as plan_count from customers_view
group by plan_name
order by plan_count desc;

-- top 5 customers by plans
select customer_id from (
select customer_id,sum(price) as total_amount_spend_by_customer from customers_view
group by customer_id
order by total_amount_spend_by_customer desc) x
limit 5;
