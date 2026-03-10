SELECT r.customer_id, r.rental_date, r.return_date 
FROM rental AS r
/* The inventory table is used to join the rental and the film table*/ 
INNER JOIN inventory AS i
  ON r.inventory_id = i.inventory_id
INNER JOIN film AS f
  ON i.film_id = f.film_id
WHERE f.length < 90;


SELECT title, rating 
FROM film 
WHERE rating IN('G', 'PG', 'R');


SELECT category AS film_category, 
       AVG(length) AS average_length
FROM film AS f
INNER JOIN category AS c
  ON f.film_id = c.film_id
WHERE release_year BETWEEN 2005 AND 2010
GROUP BY category;