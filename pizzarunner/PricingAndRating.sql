--                                        D. Pricing and Ratings

-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes how much money has Pizza Runner made so far if there are no delivery fees?
select sum(case when pizza_id = 1 then 12 else 10 end) as total_money_pizzarunner_made 
from customer_orders co
join runner_orders ro on co.order_id = ro.order_id
where pickup_time is not null;

-- What if there was an additional $1 charge for any pizza extras?
-- Add cheese is $1 extra
select sum(case when pizza_id = 1 then 12 else 10 end) + sum(case when extras is not null then 1 else 0 end) +
sum(case when extras in (select topping_id from pizza_toppings where topping_name = 'cheese') then 1 else 0 end)  as total_amount
from customer_orders co join runner_orders ro on co.order_id = ro.order_id
where pickup_time is not null; -- table is not in 1nf we need to convert into 1nf


-- The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - 
-- generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
create table customer_ratings (
customer_id int,
runner_id int,
ratings int
);

insert into customer_ratings(customer_id,runner_id,ratings)
(select customer_id,runner_id, case when runner_id = 1 then 4 
when runner_id= 2 then 5 else 3 end as ratings from customer_orders co join runner_orders ro on co.order_id = ro.order_id
where pickup_time is not null);

-- creating a trigger when there is a change in the table 
create trigger ratings_trigger
before insert on customer_ratings
for each row
set new.ratings = customer_ratings.ratings;

-- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas

select co.customer_id,
co.order_id,
cr.runner_id,
cr.ratings,
order_time,
pickup_time,
abs(Timestampdiff(minute, ro.pickup_time, co.order_time)) as preparation_time,
duration as delivery_duration,
round((distance) / (duration/60),2) as average_speed,
count(*) as no_of_pizzas 
from customer_orders co
join runner_orders ro on co.order_id = ro.order_id
join customer_ratings cr on co.customer_id = cr.customer_id
where pickup_time is not null
GROUP BY customer_id, co.order_id, cr.runner_id,cr.ratings,order_time,pickup_time,duration,distance
order by customer_id,co.order_id;

-- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled -
--  how much money does Pizza Runner have left over after these deliveries?
select (
select sum(price)
from (select pizza_id,case when pizza_id = 1 then count(*)*12 else count(*) * 10 end as price
from customer_orders co join runner_orders ro on co.order_id = ro.order_id
where pickup_time is not null
group by pizza_id) x ) - (select sum((distance * 0.30)) as runner_pay from runner_orders
where pickup_time is not null) as pizza_runner_left_money

