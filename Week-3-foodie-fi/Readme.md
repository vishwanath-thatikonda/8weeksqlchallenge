# Case Study #3 - Foodie-Fi

<p align="center">
<img src= https://8weeksqlchallenge.com/images/case-study-designs/3.png width="500" height="500" border="10"/>
</p>


## Introduction
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - 
he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their 
customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. 
This case study focuses on using subscription style digital data to answer important business questions.\
<hr>

## Entity Relationship Diagram

![image](https://github.com/user-attachments/assets/8ae72af8-e75c-4ee3-acea-5fd4d2cdab9e)

**You can get the schema design from here : [Schema Design](https://www.db-fiddle.com/f/rHJhRrXy5hbVBNJ6F6b9gJ/16)**

## Case Study Questions
This case study is split into an initial data understanding question before diving straight into data analysis questions before finishing with 1 single extension challenge.
1. [Customer Journey](https://github.com/vishwanath-thatikonda/8weeksqlchallenge/blob/main/Week-3-foodie-fi/customerjourney.sql)
2. [Data Analysis Questions](https://github.com/vishwanath-thatikonda/8weeksqlchallenge/blob/main/Week-3-foodie-fi/dataanalysis.sql)
3. Challenge Payment Question (NA)
<hr>

## Case Study Solutions:

### A. Customer Journey

We create a view for the good understanding of the table with simple syntax.

```
create view customers_view as (
select customer_id,p.*,start_date  from plans p join subscriptions s
on p.plan_id = s.plan_id);
```

* Table structure and First 5 rows of the table:
```
select * from customers_view limit 5;
```

output :

|customer_id | plan_id | plan_name | price | start_date|
|---|---|---|---|---|
|1	|0	|trial	|0.00	|2020-08-01|
|1	|1	|basic monthly	|9.90	|2020-08-08|
|2	|0	|trial	|0.00	|2020-09-20|
|2	|3	|pro annual	|199.00	|2020-09-27|
|3	|0	|trial	|0.00	|2020-01-13|

* Total individual plan count in the table:
```
select plan_name,count(*) as plan_count from customers_view
group by plan_name
order by plan_count desc;
```

output :

|plan_name |plan_count|
|---|---|
|trial	|1000|
|basic monthly	|546|
|pro monthly	|539|
|churn	|307|
|pro annual	|258|

* ***Top 5 Customers*** in the table according to their plans
```
select customer_id from (
select customer_id,sum(price) as total_amount_spend_by_customer from customers_view
group by customer_id
order by total_amount_spend_by_customer desc) x
limit 5;
```

output :

|customer_id|
|---|
|46|
|73|
|83|
|90|
|138|

<hr>

### B. Data Analysis Solutions
1. How many customers has Foodie-Fi ever had?

```
select count(distinct customer_id) as customers_count
from subscriptions;
```
Output Table : 

|customer_count|
|---|
|1000|


2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value.

```
select month(start_date) as months,
count(plan_id) as trail_plan_monthly from subscriptions
where plan_id = 0
group by month(start_date)
order by months;
```
Output Table : 

| months | trail_plan_monthly |
|---|---|
|1	|88|
|2	|68|
|3	|94|
|4	|81|
|5	|88|
|6	|79|
|7	|89|
|8	|88|
|9	|87|
|10	|79|
|11|	75|
|12|	84|
|9	|87|
|10	|79|
11	|75|
|12	|84|

3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

```
select plan_id,count(*) as count_of_plan
from subscriptions
where year(start_date) > 2020
group by plan_id
order by plan_id;
```
Output Table : 

|plan_id| plan_count |
|---|---|
|1	|8|
|2	|60|
|3	|63|
|4	|71|

4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?<br>

> [!Note]
> I've done it using a sub - query it looks like a hard query but it's very simple to understand. You can use your preferable way.

```
select sum(case when plan_id = 4 then 1 else 0 end) as total_customer_count,
round(sum(case when plan_id = 4 then 1 else 0 end) / count(distinct customer_id) * 100, 1) as churned_percentage 
from subscriptions;
```
Output Table : 

|customer_count|churned_percentage|
|---|---|
|307	|30.7|  

5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

```
select count(*) as no_of_people_churned_after_trail,
round(count(*) / (select count(distinct customer_id) from subscriptions) *100,1) as percentage_of_churn 
from(select
customer_id,
plan_id,
row_number() over(partition by customer_id) as rnk
from subscriptions) x
where x.rnk = 2 and x.plan_id = 4;
```

Output Table :

|total_people_churned| percentage_of_churn|
|---|---|
|92	|9.2|

6. What is the number and percentage of customer plans after their initial free trial?
```
select plan_id,
plan_name,
count(cnt) as plan_count,
round(count(cnt) / (select count(distinct customer_id) from subscriptions) * 100,2) as percentage
from
(select customer_id,
p.*,
start_date,
row_number() over(partition by customer_id) as cnt 
from subscriptions s
join plans p on s.plan_id = p.plan_id) x
where x.cnt = 2
group by plan_id,plan_name
order by plan_count desc;
```
Output Table :

|plan_id | plan_name | plan_count | percentage|
|---|---|---|---|
|1	|basic monthly|	546	|54.60|
|2	|pro monthly|	325	|32.50|
|4	|churn	|92	|9.20|
|3	|pro annual	|37	|3.70|

7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31

```
with cte as (
select customer_id,
p.*,
start_date,
row_number() over(partition by customer_id) as cnt 
from subscriptions s
join plans p on s.plan_id = p.plan_id)

select plan_id,
plan_name,
count(cnt) as plan_count,
round(count(cnt) / (select count(*) from subscriptions) * 100,2) as percentage
from cte
where start_date <= '2020-12-31'
group by plan_id,plan_name
order by plan_count desc;
```
Output Table :

|plan_id | plan_name | plan_count | percentage|
|---|---|---|---|
|0|	trial|	1000	|37.74|
|1	|basic monthly	|538	|20.30|
|2	|pro monthly	|479	|18.08|
|4	|churn	|236	|8.91|
|3	|pro annual	|195	|7.36|

8. How many customers have upgraded to an annual plan in 2020?

```
with cte as (
select customer_id,
p.*,
start_date 
from subscriptions s
join plans p on s.plan_id = p.plan_id)

select count(distinct customer_id) as customer_count
from cte
where plan_id = 3 and year(start_date) = 2020;
```
Output Table :

|customer_count|
|---|
|195|

9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?\
<br>

> [!NOTE]
> FYI I just tried i don't know exactly how to do this, tou can feel free to edit this on your own.

```
with annual_plan_cte as (
select customer_id,
p.*,
start_date,
lag(start_date) over(partition by customer_id order by start_date) as next_day
from subscriptions s
join plans p on s.plan_id = p.plan_id)

select avg(start_date-next_day) no_of_days
 from annual_plan_cte
where start_date is not null and next_day is not null and plan_id in (0,3)
```

10. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

```
with downgraded_cte as (
select customer_id,
p.plan_id,
ROW_NUMBER() over(partition by customer_id) as rn
from subscriptions s
join plans p on s.plan_id = p.plan_id)

select sum(case when plan_id = 2 and rn = 4 then 1 else 0 end) as customer_count from downgraded_cte;
```
Output Table :

|customer_count|
|---|
| 0 |
