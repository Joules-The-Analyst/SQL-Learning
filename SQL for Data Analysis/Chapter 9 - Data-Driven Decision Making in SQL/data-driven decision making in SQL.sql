-- SELECT *
-- FROM renting
-- WHERE date_renting = '2018-10-09'; -- Movies rented on October 9th, 2018

-- SELECT *
-- FROM renting
-- WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'; -- from beginning April 2018 to end August 2018

-- SELECT *
-- FROM renting
-- WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'
-- ORDER BY date_renting DESC; -- Order by recency in decreasing order

-- SELECT *
-- FROM movies
-- WHERE genre <> 'Drama'; -- All genres except drama

-- SELECT *
-- FROM movies
-- WHERE title IN ('Showtime', 'Love Actually', 'The Fighter'); -- Select all movies with the given titles

-- SELECT *
-- FROM movies
-- ORDER BY renting_price; -- Order the movies by increasing renting price

-- SELECT *
-- FROM renting
-- WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' -- Renting in 2018
-- AND rating IS NOT NULL; -- Rating exists

-- SELECT count(*) -- Count the total number of customers
-- FROM customers
-- WHERE date_of_birth BETWEEN '1980-01-01' AND '1989-12-31'; -- Select customers born between 1980-01-01 and 1989-12-31

-- SELECT count(customer_id)   -- Count the total number of customers
-- FROM customers
-- WHERE country = 'Germany'; -- Select all customers from Germany

-- SELECT count(DISTINCT country)   -- Count the number of countries
-- FROM customers;

-- SELECT min(rating) AS min_rating, -- Calculate the minimum rating and use alias min_rating
-- 	   max(rating) AS max_rating, -- Calculate the maximum rating and use alias max_rating
-- 	   avg(rating) AS avg_rating, -- Calculate the average rating and use alias avg_rating
-- 	   count(rating) AS number_ratings -- Count the number of ratings and use alias number_ratings
-- FROM renting
-- WHERE movie_id = 25; -- Select all records of the movie with ID 25

-- SELECT 
-- 	COUNT(*) AS number_renting,
-- 	AVG(rating) AS average_rating, 
--     COUNT(rating) AS number_ratings -- Add the total number of ratings here.
-- FROM renting
-- WHERE date_renting >= '2019-01-01';



-- -- -- GROUPING IN SQL
-- SELECT country, -- For each country report the earliest date when an account was created
-- 	min(date_account_start) AS first_account
-- FROM customers
-- GROUP BY country
-- ORDER BY first_account;

-- SELECT movie_id, 
--        AVG(rating) AS avg_rating,
--        COUNT(rating) AS number_ratings,
--        COUNT(*) AS number_renting
-- FROM renting
-- GROUP BY movie_id
-- ORDER BY avg_rating DESC; -- Order by average rating in decreasing order

-- SELECT customer_id, -- Report the customer_id
--       AVG(rating),  -- Report the average rating per customer
--       COUNT(rating),  -- Report the number of ratings per customer
--       COUNT(*)  -- Report the number of movie rentals per customer
-- FROM renting
-- GROUP BY customer_id
-- HAVING COUNT(*) > 7 -- Select only customers with more than 7 movie rentals
-- ORDER BY AVG(rating); -- Order by the average rating in ascending order


-- -- -- REVISION OF JOINS
-- SELECT AVG(r.rating) -- Average ratings of customers from Belgium
-- FROM renting AS r
-- LEFT JOIN customers AS c
-- ON r.customer_id = c.customer_id
-- WHERE c.country='Belgium';

-- SELECT 
-- 	SUM(m.renting_price), 
-- 	COUNT(*), 
-- 	COUNT(DISTINCT r.customer_id)
-- FROM renting AS r
-- LEFT JOIN movies AS m
-- ON r.movie_id = m.movie_id
-- -- Only look at movie rentals in 2018
-- WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' ;


-- SELECT m.title, -- Create a list of movie titles and actor names
--        a.name
-- FROM actsin AS ai
-- LEFT JOIN movies AS m
-- ON m.movie_id = ai.movie_id
-- LEFT JOIN actors AS a
-- ON a.actor_id = ai.actor_id;

-- SELECT m.title, -- Use a join to get the movie title and price for each movie rental
--        m.renting_price
-- FROM renting AS r
-- LEFT JOIN movies AS m
-- ON r.movie_id = m.movie_id;

-- SELECT rm.title, -- Report the income from movie rentals for each movie 
--        SUM(rm.renting_price) AS income_movie
-- FROM
--        (SELECT m.title,  
--                m.renting_price
--        FROM renting AS r
--        LEFT JOIN movies AS m
--        ON r.movie_id=m.movie_id) AS rm
-- GROUP BY rm.title
-- ORDER BY income_movie DESC; -- Order the result by decreasing income

-- SELECT a.gender, -- Report for male and female actors from the USA 
--        MIN(a.year_of_birth), -- The year of birth of the oldest actor
--        MAX(a.year_of_birth) -- The year of birth of the youngest actor
-- FROM
--    (SELECT *
--    FROM actors
--    WHERE nationality = 'USA') -- Use a subsequen SELECT to get all information about actors from the USA
--    AS a -- Give the table the name a
-- GROUP BY gender;

-- SELECT m.title, 
-- COUNT(*),
-- AVG(r.rating)
-- FROM renting AS r
-- LEFT JOIN customers AS c
-- ON c.customer_id = r.customer_id
-- LEFT JOIN movies AS m
-- ON m.movie_id = r.movie_id
-- WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
-- GROUP BY m.title
-- HAVING COUNT(*) > 1 -- Remove movies with only one rental
-- ORDER BY AVG(r.rating) DESC; -- Order with highest rating first


-- SELECT a.name,  c.gender,
--        COUNT(*) AS number_views, 
--        AVG(r.rating) AS avg_rating
-- FROM renting as r
-- LEFT JOIN customers AS c
-- ON r.customer_id = c.customer_id
-- LEFT JOIN actsin as ai
-- ON r.movie_id = ai.movie_id
-- LEFT JOIN actors as a
-- ON ai.actor_id = a.actor_id
-- WHERE c.country = 'Spain' -- Select only customers from Spain
-- GROUP BY a.name, c.gender
-- HAVING AVG(r.rating) IS NOT NULL 
--   AND COUNT(*) > 5 
-- ORDER BY avg_rating DESC, number_views DESC;

-- SELECT 
-- 	c.country,                    -- For each country report
-- 	COUNT(*) AS number_renting, -- The number of movie rentals
-- 	AVG(r.rating) AS average_rating, -- The average rating
-- 	SUM(m.renting_price) AS revenue         -- The revenue from movie rentals
-- FROM renting AS r
-- LEFT JOIN customers AS c
-- ON c.customer_id = r.customer_id
-- LEFT JOIN movies AS m
-- ON m.movie_id = r.movie_id
-- WHERE date_renting >= '2019-01-01'
-- GROUP BY c.country;



-- -- NESTED QUERY
-- SELECT *
-- FROM movies
-- WHERE movie_id IN  -- Select movie IDs from the inner query
-- 	(SELECT movie_id
-- 	FROM renting
-- 	GROUP BY movie_id
-- 	HAVING COUNT(*) > 5)


-- SELECT *
-- FROM customers
-- WHERE customer_id IN      -- Select all customers with more than 10 movie rentals
-- 	(SELECT customer_id
-- 	FROM renting
-- 	GROUP BY customer_id
-- 	HAVING count(*) > 10);


-- SELECT title -- Report the movie titles of all movies with average rating higher than the total average
-- FROM movies
-- WHERE movie_id IN
-- 	(SELECT movie_id
-- 	 FROM renting
--      GROUP BY movie_id
--      HAVING AVG(rating) > 
-- 		(SELECT AVG(rating)
-- 		 FROM renting));


-- -- UNION AND INTERSECT
-- SELECT name, 
--        nationality, 
--        year_of_birth
-- FROM actors
-- WHERE nationality <> 'USA'
-- INTERSECT -- Select all actors who are not from the USA and who are also born after 1990
-- SELECT name, 
--        nationality, 
--        year_of_birth
-- FROM actors
-- WHERE year_of_birth > 1990;

-- SELECT name, 
--        nationality, 
--        year_of_birth
-- FROM actors
-- WHERE nationality <> 'USA'
-- UNION -- Select all actors who are not from the USA and all actors who are born after 1990
-- SELECT name, 
--        nationality, 
--        year_of_birth
-- FROM actors
-- WHERE year_of_birth > 1990;

-- SELECT *
-- FROM movies
-- WHERE movie_id IN -- Select all movies of genre drama with average rating higher than 9
--    (SELECT movie_id
--     FROM movies
--     WHERE genre = 'Drama'
--     INTERSECT
--     SELECT movie_id
--     FROM renting
--     GROUP BY movie_id
--     HAVING AVG(rating)>9);



-- -- OLAP IN SQL
-- -- GROUP BY USING CUBE OPERATOR
-- SELECT gender, -- Extract information of a pivot table of gender and country for the number of customers
-- 	   country,
-- 	   COUNT(*)
-- FROM customers
-- GROUP BY CUBE (gender, country)
-- ORDER BY country;

-- SELECT 
-- 	country, 
-- 	genre, 
-- 	AVG(r.rating) AS avg_rating -- Calculate the average rating 
-- FROM renting AS r
-- LEFT JOIN movies AS m
-- ON m.movie_id = r.movie_id
-- LEFT JOIN customers AS c
-- ON r.customer_id = c.customer_id
-- GROUP BY CUBE (country, genre); -- For all aggregation levels of country and genre


-- -- GROUP BY USING ROLLUP OPERATOR
-- -- Count the total number of customers, the number of customers for each country, and the number of female and male customers for each country
-- SELECT country,
--        gender,
-- 	   COUNT(*)
-- FROM customers
-- GROUP BY ROLLUP (country, gender)
-- ORDER BY country, gender; -- Order the result by country and gender

-- -- Group by each county and genre with OLAP extension
-- SELECT 
-- 	c.country, 
-- 	m.genre, 
-- 	AVG(r.rating) AS avg_rating, 
-- 	COUNT(*) AS num_rating
-- FROM renting AS r
-- LEFT JOIN movies AS m
-- ON m.movie_id = r.movie_id
-- LEFT JOIN customers AS c
-- ON r.customer_id = c.customer_id
-- GROUP BY ROLLUP (country, genre)
-- ORDER BY c.country, m.genre;


-- -- GROUPING SETS
-- SELECT 
-- 	nationality, -- Select nationality of the actors
--     gender, -- Select gender of the actors
--     COUNT(*) -- Count the number of actors
-- FROM actors
-- GROUP BY GROUPING SETS ((nationality), (gender), ()); -- Use the correct GROUPING SETS operation

-- SELECT 
-- 	c.country, 
--     c.gender,
-- 	AVG(r.rating)
-- FROM renting AS r
-- LEFT JOIN customers AS c
-- ON r.customer_id = c.customer_id
-- -- Report all info from a Pivot table for country and gender
-- GROUP BY GROUPING SETS ((country, gender), (country), (gender), ());

-- SELECT genre,
-- 	   AVG(rating) AS avg_rating,
-- 	   COUNT(rating) AS n_rating,
--        COUNT(*) AS n_rentals,     
-- 	   COUNT(DISTINCT m.movie_id) AS n_movies 
-- FROM renting AS r
-- LEFT JOIN movies AS m
-- ON m.movie_id = r.movie_id
-- WHERE r.movie_id IN ( 
-- 	SELECT movie_id
-- 	FROM renting
-- 	GROUP BY movie_id
-- 	HAVING COUNT(rating) >= 3 )
-- AND r.date_renting >= '2018-01-01'
-- GROUP BY genre
-- ORDER BY avg_rating DESC; -- Order the table by decreasing average rating



-- SELECT a.nationality,
--        a.gender,
-- 	   AVG(r.rating) AS avg_rating,
-- 	   COUNT(r.rating) AS n_rating,
-- 	   COUNT(*) AS n_rentals,
-- 	   COUNT(DISTINCT a.actor_id) AS n_actors
-- FROM renting AS r
-- LEFT JOIN actsin AS ai
-- ON ai.movie_id = r.movie_id
-- LEFT JOIN actors AS a
-- ON ai.actor_id = a.actor_id
-- WHERE r.movie_id IN ( 
-- 	SELECT movie_id
-- 	FROM renting
-- 	GROUP BY movie_id
-- 	HAVING COUNT(rating) >= 4)
-- AND r.date_renting >= '2018-04-01'
-- GROUP BY GROUPING SETS ((a.nationality, a.gender), (a.nationality), (a.gender), ()); -- Provide results for all aggregation levels represented in a pivot table