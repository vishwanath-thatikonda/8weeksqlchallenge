
-- CREATE SCHEMA dannys_diner;
-- You can change the values as per your requirements but the structure of tables and datbase should be same
use dannys_diner;
CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  -- Queries to be solved for the case Study....
-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?



                                         -- Dannys Diner Case Study Solutions --


-- creating a view for readabilty of the query

-- create view complete_table as 
-- select s.customer_id,s.order_date,s.product_id,m.product_name,price,join_date from sales s 
-- join menu m on s.product_id = m.product_id
-- left join members me on s.customer_id = me.customer_id
-- order by customer_id;

-- 1. What is the total amount each customer spent at the restaurant?
select customer_id, sum(price) as total_amount_spent_by_customer from sales s
join menu m on s.product_id = m.product_id
group by customer_id
order by total_amount_spent_by_customer desc;

-- 2. How many days has each customer visited the restaurant?
select customer_id, count(order_date) as customer_visited_days from sales
group by customer_id
order by customer_visited_days desc;

-- 3. What was the first item from the menu purchased by each customer?
select customer_id, product_name as first_purchased_item from (
select customer_id, product_name,row_number() over(partition by customer_id) as first_order  from sales s
join menu m on s.product_id = m.product_id) x
where x.first_order = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select product_name as most_purchased_item,count(*) as total_purchased from sales s
join menu m on s.product_id = m.product_id
group by product_name
order by total_purchased desc
limit 1;

-- 5. Which item was the most popular for each customer?
select distinct customer_id,product_name,count(*) as most_popular from complete_table
group by customer_id,product_name
order by most_popular desc
limit 4;


-- 6. Which item was purchased first by the customer after they became a member?
select customer_id,product_name as first_purchased_product from (
select s.customer_id,product_name ,order_date, row_number() over(partition by s.customer_id) as rnk from sales s 
join menu m on s.product_id = m.product_id
join members me on s.customer_id = me.customer_id
where order_date > join_date
order by order_date ) as x
where x.rnk = 1;

-- 7. Which item was purchased just before the customer became a member?
select customer_id,product_name from complete_table
where order_date <= join_date
group by customer_id,product_name
order by customer_id;

-- 8. What is the total items and amount spent for each member before they became a member?
select customer_id,count(*) as total_items, sum(price) as total_amount_before_memeber from complete_table
where order_date < join_date
group by customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select customer_id,sum(points) as total_customer_points from (
select customer_id, case when product_name = 'sushi' then price * 20 
else price * 10 end as points from complete_table) x
group by x.customer_id
order by total_customer_points  desc;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
select customer_id, sum(points) as total_points_after_join_before_feb from (
select customer_id,(price * 20) as points from complete_table
where order_date >= join_date and month(order_date) < 2 ) x
group by x.customer_id
order by customer_id;







