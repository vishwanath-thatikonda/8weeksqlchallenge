
**Case Study of Pizza Runner**
                                                
-- This case study has LOTS of questions - they are broken up by area of focus including:

-- Pizza Metrics
-- Runner and Customer Experience
-- Ingredient Optimisation
-- Pricing and Ratings
-- Bonus DML Challenges (DML = Data Manipulation Language)

You can find these cases studies in [8weekSQLchallenge](https://8weeksqlchallenge.com/)

The Tables in the pizza_runners schema are:
* customer_orders
* runner_orders
* runners
* pizza_names
* pizza_recipes
* pizza_toppings

You can find the schema diagram here [Schema Diagram](https://dbdiagram.io/d/Pizza-Runner-5f3e085ccf48a141ff558487?utm_source=dbdiagram_embed&utm_medium=bottom_open)


**The schema is present in pizzarunnerschema.sql, and we are cleaning the table and null values.**

update customer_orders
set exclusions = null
where exclusions = 'null' or exclusions = '';

update customer_orders
set extras = null
where extras = 'null' or extras = '';

update runner_orders
set pickup_time = null,distance = null,duration = null
where pickup_time = 'null';

update runner_orders
set cancellation = null
where cancellation = 'null' or cancellation = '';

