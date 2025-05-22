--                                   B. Runner and Customer Experience
-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
-- What was the average distance travelled for each customer?
-- What was the difference between the longest and shortest delivery times for all orders?
-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
-- What is the successful delivery percentage for each runner?

-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select weekday(date(registration_date)) as runner_signed_week,count(*) as runners_signed_count from runners
group by weekday(date(registration_date));

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select runner_id,round(avg(abs(Timestampdiff(minute, pickup_time, order_time))),2) as avg_minutes_to_arrive 
from customer_orders co join runner_orders ro on co.order_id = ro.order_id
where pickup_time is not null
group by runner_id;

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
select co.order_id,pizza_id,abs(Timestampdiff(minute, pickup_time, order_time)) as order_preparation_time 
from customer_orders co join runner_orders ro on co.order_id = ro.order_id
where pickup_time is not null;


-- What was the average distance travelled for each customer?
select customer_id,round(avg(distance),2) as average_distance from runner_orders ro join customer_orders co 
on co.order_id = ro.order_id
where pickup_time is not null
group by customer_id;

-- What was the difference between the longest and shortest delivery times for all orders?
select max(duration) - min(duration) as diff_between_longest_and_shortest_delivery_time
from customer_orders co join runner_orders ro on co.order_id = ro.order_id
where pickup_time is not null;

-- What was the average speed for each runner for each delivery and do you notice any trend for these value
select runner_id,avg(round((distance) / (duration/60),2)) as avg_speed from runner_orders
group by runner_id;

-- What is the successful delivery percentage for each runner?
select runner_id,(count(pickup_time) / count(*)) * 100 as successful_delivery_percentage from runner_orders
group by runner_id



