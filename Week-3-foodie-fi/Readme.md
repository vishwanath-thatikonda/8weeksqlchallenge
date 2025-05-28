# Case Study #3 - Foodie-Fi
## Introduction
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - 
he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their 
customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. 
This case study focuses on using subscription style digital data to answer important business questions.\
<hr>

[Entity Relationship Diagram](https://8weeksqlchallenge.com/images/case-study-3-erd.png)

## Case Study Questions
This case study is split into an initial data understanding question before diving straight into data analysis questions before finishing with 1 single extension challenge.
1. Customer Journey
2. Data Analysis Questions
3. Challenge Payment Question
<hr>

## Case Study Solutions:
### A. Data Analysis Questions
1.How many customers has Foodie-Fi ever had?

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
select plan_id,count(*) as count_of_plan from subscriptions
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
-- I've done it using a sub - query it looks like a hard query but it's very simple to understand. You can use your preferable way.

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
from (select customer_id,plan_id,row_number() over(partition by customer_id) as rnk from subscriptions) x
where x.rnk = 2 and x.plan_id = 4;
```

Output Table :

|total_people_churned| percentage_of_churn|
|---|---|
|92	|9.2|

6. What is the number and percentage of customer plans after their initial free trial?
```
```
