**Case Study of Pizza Runner**
                                                
This case study has LOTS of questions - they are broken up by area of focus including:

1. Pizza Metrics
2. Runner and Customer Experience
3. Ingredient Optimisation
4. Pricing and Ratings

You can find these cases studies in [8weekSQLchallenge](https://8weeksqlchallenge.com/)

The Tables in the pizza_runners schema are:
* customer_orders
* runner_orders
* runners
* pizza_names
* pizza_recipes
* pizza_toppings

You can find the schema diagram here [Entity Relationship Diagram](https://dbdiagram.io/d/Pizza-Runner-5f3e085ccf48a141ff558487?utm_source=dbdiagram_embed&utm_medium=bottom_open)

You can get the schema design from [Database Design](https://www.db-fiddle.com/f/7VcQKQwsS3CTkGRFG7vu98/65) 
or follow the pizzarunnersschema.sql file.

The customer_orders looks like this:

![Screenshot 2025-05-22 133516](https://github.com/user-attachments/assets/ee103597-1c16-4df9-8297-2170cb5b6cb5)

runenrs_orders table:

![Screenshot 2025-05-22 144244](https://github.com/user-attachments/assets/4ad549c2-0e9a-4faa-a30c-da4b547386ee)

runners table:

![Screenshot 2025-05-22 144326](https://github.com/user-attachments/assets/a739c882-7056-42b3-ab49-7060bd08e80c)

pizza_names table

![Screenshot 2025-05-22 144405](https://github.com/user-attachments/assets/dd67e039-3f45-4e06-b87b-e95d877ec06e)

pizza_recipes table:

![Screenshot 2025-05-22 144443](https://github.com/user-attachments/assets/0224314b-5488-48ea-ad5e-d94ce4334771)

pizza_toppings table:

![Screenshot 2025-05-22 144553](https://github.com/user-attachments/assets/cd92f14c-df43-442e-8634-987acb30599b)

**1.Pizza Metrics**/
1.How many pizzas were ordered?
select count(order_id) as total_pizza_orders from customer_orders;

![Screenshot 2025-05-22 145454](https://github.com/user-attachments/assets/ae92351b-eb4f-49bc-a673-c8a237810671)

2.How many unique customer orders were made?
select count(distinct order_id) as unique_customer_orders from customer_orders;

![Screenshot 2025-05-22 145551](https://github.com/user-attachments/assets/eabb58ca-c48e-460c-a7fc-2f5e74175b3c)

   





