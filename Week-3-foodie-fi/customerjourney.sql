--                                                A. Customer Journey
-- Based off the 8 sample customers provided in the sample from the subscriptions table, 
-- write a brief description about each customer’s onboarding journey.

-- Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

select plan_name,sum(price) as total_price from plans p join subscriptions s
on p.plan_id = s.plan_id
where price is not null
group by plan_name