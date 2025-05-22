                                            --       Case Study Questions
-- This case study has LOTS of questions - they are broken up by area of focus including:

-- Pizza Metrics
-- Runner and Customer Experience
-- Ingredient Optimisation
-- Pricing and Ratings
-- Bonus DML Challenges (DML = Data Manipulation Language)

--                                                       A. Pizza Metrics
-- How many pizzas were ordered?
-- How many unique customer orders were made?
-- How many successful orders were delivered by each runner?
-- How many of each type of pizza was delivered?
-- How many Vegetarian and Meatlovers were ordered by each customer?
-- What was the maximum number of pizzas delivered in a single order?
-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- How many pizzas were delivered that had both exclusions and extras?
-- What was the total volume of pizzas ordered for each hour of the day?
-- What was the volume of orders for each day of the week?



-- How many pizzas were ordered?
select count(order_id) as total_pizza_orders from customer_orders;

-- How many unique customer orders were made?
select count(distinct order_id) as unique_customer_orders from customer_orders;

-- How many successful orders were delivered by each runner?
select runner_id,count(*) as sucessful_orders from runner_orders ro join customer_orders co on ro.order_id = co.order_id
where pickup_time is not null
group by runner_id;

-- How many of each type of pizza was delivered?
select pizza_name,count(*) as no_of_pizzas_ordered from customer_orders co join pizza_names pn on co.pizza_id = pn.pizza_id
group by pizza_name;

-- How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id,pizza_name,count(*) as no_of_pizzas_ordered from customer_orders co join pizza_names pn on co.pizza_id = pn.pizza_id
group by customer_id,pizza_name
order by customer_id;
-- or
select customer_id,
sum(case when co.pizza_id = 1 then 1 else 0 end) as no_of_meatlovers_ordered,
sum(case when co.pizza_id = 2 then 1 else 0 end ) no_of_vegetarian_orderes
from customer_orders co join pizza_names pn on co.pizza_id = pn.pizza_id
group by customer_id;

-- What was the maximum number of pizzas delivered in a single order?
select order_id,count(*) as maximun_pizzas_per_order from customer_orders
group by order_id
order by maximun_pizzas_per_order desc
limit 1;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select customer_id, sum(case when exclusions is null and extras is null then 1 else 0 end) as no_changes,
sum(case when exclusions is not null or extras is not null then 1 else 0 end) as atleast_1_change from
customer_orders co join runner_orders ro on co.order_id = ro.order_id
where pickup_time is not null
group by customer_id;


-- How many pizzas were delivered that had both exclusions and extras?
select count(co.order_id) as pizza_delivered_with_exclusions_and_extras from customer_orders co
join runner_orders ro on co.order_id = ro.order_id
where pickup_time is not null and exclusions is not null and extras is not null;

-- What was the total volume of pizzas ordered for each hour of the day?
select date(order_time) as ordered_date, hour(order_time) as ordered_hour,count(*) as total_pizzas_each_hour from customer_orders
group by date(order_time),hour(order_time)
order by ordered_date;

-- What was the volume of orders for each day of the week?
select dayname(order_time) AS day_name, count(*) as no_of_orders
from customer_orders
group by dayname(order_time);








