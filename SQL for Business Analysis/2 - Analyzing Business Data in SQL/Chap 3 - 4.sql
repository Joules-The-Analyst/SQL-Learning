-- -- Create a CTE named kpi
-- WITH kpi AS (
--   SELECT
--     -- Select the user ID and calculate revenue
--     user_id,
--     SUM(m.meal_price * o.order_quantity) AS revenue
--   FROM meals AS m
--   JOIN orders AS o ON m.meal_id = o.meal_id
--   GROUP BY user_id)
-- -- Calculate ARPU
-- SELECT ROUND(AVG(revenue) :: NUMERIC, 2) AS arpu
-- FROM kpi;


-- WITH kpi AS (
--   SELECT
--     -- Select the week, revenue, and count of users
--     DATE_TRUNC('week', order_date) :: DATE AS delivr_week,
--     SUM(m.meal_price * order_quantity) AS revenue,
--     COUNT(DISTINCT o.user_id) AS users
--   FROM meals AS m
--   JOIN orders AS o ON m.meal_id = o.meal_id
--   GROUP BY delivr_week)

-- SELECT
--   delivr_week,
--   -- Calculate ARPU
--   ROUND(
--     revenue :: NUMERIC / GREATEST(users, 1),
--   2) AS arpu
-- FROM kpi
-- -- Order by week in ascending order
-- ORDER BY delivr_week ASC;


-- WITH kpi AS (
--   SELECT
--     -- Select the count of orders and users
--     COUNT(DISTINCT order_id) AS orders,
--     COUNT(DISTINCT user_id) AS users
--   FROM orders)

-- SELECT
--   -- Calculate the average orders per user
--   ROUND(
--     orders :: NUMERIC / GREATEST(users, 1),
--   2) AS arpu
-- FROM kpi;


-- WITH user_revenues AS (
--   SELECT
--     -- Select the user ID and revenue
--     user_id,
--     SUM(meal_price * order_quantity) AS revenue
--   FROM meals AS m
--   JOIN orders AS o ON m.meal_id = o.meal_id
--   GROUP BY user_id)

-- SELECT
--   -- Return the frequency table of revenues by user
--   ROUND(revenue :: NUMERIC, -2) AS revenue_100,
--   COUNT(user_id) AS users
-- FROM user_revenues
-- GROUP BY revenue_100
-- ORDER BY revenue_100 ASC;


-- WITH user_orders AS (
--   SELECT
--     user_id,
--     COUNT(DISTINCT order_id) AS orders
--   FROM orders
--   GROUP BY user_id)

-- SELECT
--   -- Return the frequency table of orders by user
--   orders,
--   COUNT(DISTINCT user_id) AS users
-- FROM user_orders
-- GROUP BY orders
-- ORDER BY orders ASC;


-- WITH user_revenues AS (
--   SELECT
--     -- Select the user IDs and the revenues they generate
--     user_id,
--     SUM(meal_price * order_quantity) AS revenue
--   FROM meals AS m
--   JOIN orders AS o ON m.meal_id = o.meal_id
--   GROUP BY user_id)

-- SELECT
--   -- Fill in the bucketing conditions
--   CASE
--     WHEN revenue < 150 THEN 'Low-revenue users'
--     WHEN revenue < 300 THEN 'Mid-revenue users'
--     ELSE 'High-revenue users'
--   END AS revenue_group,
--   COUNT(DISTINCT user_id) AS users
-- FROM user_revenues
-- GROUP BY revenue_group;


-- -- Store each user's count of orders in a CTE named user_orders
-- WITH user_orders AS (
--   SELECT
--     user_id,
--     COUNT(DISTINCT order_id) AS orders
--   FROM orders
--   GROUP BY user_id)

-- SELECT
--   -- Write the conditions for the three buckets
--   CASE
--     WHEN orders < 8 THEN 'Low-orders users'
--     WHEN orders < 15 THEN 'Mid-orders users'
--     ELSE 'High-orders users'
--   END AS order_group,
--   -- Count the distinct users in each bucket
--   COUNT(DISTINCT user_id) AS users
-- FROM user_orders
-- GROUP BY order_group;


-- WITH user_revenues AS (
--   -- Select the user IDs and their revenues
--   SELECT
--     user_id,
--     SUM(meal_price * order_quantity) AS revenue
--   FROM meals AS m
--   JOIN orders AS o ON m.meal_id = o.meal_id
--   GROUP BY user_id)

-- SELECT
--   -- Calculate the first, second, and third quartile
--   ROUND(
--     PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue ASC):: NUMERIC,
--   2) AS revenue_p25,
--   ROUND(
--     PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue ASC):: NUMERIC,
--   2) AS revenue_p50,
--   ROUND(
--     PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue ASC):: NUMERIC,
--   2) AS revenue_p75,
--   -- Calculate the average
--   ROUND(AVG(revenue) :: NUMERIC, 2) AS avg_revenue
-- FROM user_revenues;


-- WITH user_revenues AS (
--   SELECT
--     -- Select user_id and calculate revenue by user 
--     user_id,
--     SUM(m.meal_price * o.order_quantity) AS revenue
--   FROM meals AS m
--   JOIN orders AS o ON m.meal_id = o.meal_id
--   GROUP BY user_id),

--   quartiles AS (
--   SELECT
--     -- Calculate the first and third revenue quartiles
--     ROUND(
--       PERCENTILE_CONT(0.25) WITHIN GROUP
--       (ORDER BY revenue ASC) :: NUMERIC,
--     2) AS revenue_p25,
--     ROUND(
--       PERCENTILE_CONT(0.75) WITHIN GROUP
--       (ORDER BY revenue ASC) :: NUMERIC,
--     2) AS revenue_p75
--   FROM user_revenues)

-- SELECT
--   -- Count the number of users in the IQR
--   COUNT(DISTINCT user_id) AS users
-- FROM user_revenues
-- CROSS JOIN quartiles
-- -- Only keep users with revenues in the IQR range
-- WHERE revenue :: NUMERIC >= revenue_p25
--   AND revenue :: NUMERIC <= revenue_p75;


-- SELECT DISTINCT
--   -- Select the order date
--   order_date,
--   -- Format the order date
--   TO_CHAR(order_date, 'FMDay DD, FMMonth YYYY') AS format_order_date
-- FROM orders
-- ORDER BY order_date ASC
-- LIMIT 3;


-- -- Set up the user_count_orders CTE
-- WITH user_count_orders AS (
--   SELECT
--     user_id,
--     COUNT(DISTINCT order_id) AS count_orders
--   FROM orders
--   -- Only keep orders in August 2018
--   WHERE DATE_TRUNC('month', order_date) = '2018-08-01'
--   GROUP BY user_id)

-- SELECT
--   -- Select user ID, and rank user ID by count_orders
--   user_id,
--   RANK() OVER(ORDER BY count_orders DESC) AS count_orders_rank
-- FROM user_count_orders
-- ORDER BY count_orders_rank ASC
-- -- Limit the user IDs selected to 3
-- LIMIT 3;


-- -- Import tablefunc
-- CREATE EXTENSION IF NOT EXISTS tablefunc;

-- SELECT * FROM CROSSTAB($$
--   SELECT
--     user_id,
--     DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
--     SUM(meal_price * order_quantity) :: FLOAT AS revenue
--   FROM meals
--   JOIN orders ON meals.meal_id = orders.meal_id
--  WHERE user_id IN (0, 1, 2, 3, 4)
--    AND order_date < '2018-09-01'
--  GROUP BY user_id, delivr_month
--  ORDER BY user_id, delivr_month;
-- $$)
-- -- Select user ID and the months from June to August 2018
-- AS ct (user_id INT,
--        "2018-06-01" FLOAT,
--        "2018-07-01" FLOAT,
--        "2018-08-01" FLOAT)
-- ORDER BY user_id ASC;


-- -- Import tablefunc
-- CREATE EXTENSION IF NOT EXISTS tablefunc;

-- SELECT * FROM CROSSTAB($$
--   SELECT
--     -- Select eatery and calculate total cost
--     eatery,
--     DATE_TRUNC('month', stocking_date) :: DATE AS delivr_month,
--     SUM(meal_cost * stocked_quantity) :: FLOAT AS cost
--   FROM meals
--   JOIN stock ON meals.meal_id = stock.meal_id
--   -- Keep only the records after October 2018
--   WHERE DATE_TRUNC('month', stocking_date) > '2018-10-01'
--   GROUP BY eatery, delivr_month
--   ORDER BY eatery, delivr_month;
-- $$)

-- -- Select the eatery and November and December 2018 as columns
-- AS ct (eatery TEXT,
--        "2018-11-01" FLOAT,
--        "2018-12-01" FLOAT)
-- ORDER BY eatery ASC;


-- Import tablefunc
CREATE EXTENSION IF NOT EXISTS tablefunc;

-- -- Pivot the previous query by quarter
-- SELECT * FROM CROSSTAB ($$
--   WITH eatery_users AS  (
--     SELECT
--       eatery,
--       -- Format the order date so "2018-06-01" becomes "Q2 2018"
--       TO_CHAR(order_date, '"Q"Q YYYY') AS delivr_quarter,
--       -- Count unique users
--       COUNT(DISTINCT user_id) AS users
--     FROM meals
--     JOIN orders ON meals.meal_id = orders.meal_id
--     GROUP BY eatery, delivr_quarter
--     ORDER BY delivr_quarter, users)

--   SELECT
--     -- Select eatery and quarter
--     eatery,
--     delivr_quarter,
--     -- Rank rows, partition by quarter and order by users
--     RANK() OVER
--       (PARTITION BY delivr_quarter
--        ORDER BY users DESC) :: INT AS users_rank
--   FROM eatery_users
--   ORDER BY eatery, delivr_quarter;
-- $$)
-- -- Select the columns of the pivoted table
-- AS  ct (eatery TEXT,
--         "Q2 2018" INT,
--         "Q3 2018" INT,
--         "Q4 2018" INT)
-- ORDER BY "Q4 2018";


