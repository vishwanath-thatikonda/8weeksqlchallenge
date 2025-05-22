 -- The schema is present in pizzarunnerschema.sql and we cleaning the table and null values

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


