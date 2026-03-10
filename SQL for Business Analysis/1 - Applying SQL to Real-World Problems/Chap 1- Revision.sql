SELECT title, description
FROM film AS f
INNER JOIN language AS l
  ON f.language_id = l.language_id
WHERE l.name IN ('Italian', 'French')
  AND release_year = 2005 ;

SELECT c.first_name,
	   c.last_name,
       p.amount
FROM payment AS p
INNER JOIN customer AS c
  ON p.customer_id = c.customer_id
WHERE c.active IS true
ORDER BY p.amount DESC;

SELECT LOWER(title) AS title, 
  rental_rate AS original_rate, 
  rental_rate * 0.5 AS sale_rate 
FROM film
-- Filter for films prior to 2006
WHERE release_year < 2006;

SELECT payment_date,
  EXTRACT(DAY FROM payment_date) AS payment_day 
FROM payment;

SELECT payment_date,
  EXTRACT(YEAR FROM payment_date) AS payment_year 
FROM payment;

SELECT payment_date,
  EXTRACT(HOUR FROM payment_date) AS payment_hour 
FROM payment;

SELECT active, 
       COUNT(payment_id) AS num_transactions, 
       AVG(amount) AS avg_amount, 
       SUM(amount) AS total_amount
FROM payment AS p
INNER JOIN customer AS c
  ON p.customer_id = c.customer_id
GROUP BY active;

SELECT name, 
	STRING_AGG(title, ',') AS film_titles
FROM film AS f
INNER JOIN language AS l
  ON f.language_id = l.language_id
WHERE release_year = 2010
  AND rating = 'G'
GROUP BY name;

