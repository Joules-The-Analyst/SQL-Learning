-- -- -- Comment out the previous query
-- -- SELECT AVG(CAST(pop_in_millions AS float)) AS avg_population
-- -- FROM country_stats;

-- -- Uncomment the following block & run the query
-- SELECT 
-- 	s.country_id, 
--     COUNT(DISTINCT s.athlete_id) AS summer_athletes, 
--     COUNT(DISTINCT w.athlete_id) AS winter_athletes
-- FROM summer_games AS s
-- JOIN winter_games_str AS w
-- -- Fix the error by making both columns integers
-- ON s.country_id = CAST(w.country_id AS INT)
-- GROUP BY s.country_id;


-- SELECT 
-- 	year,
--     -- Pull decade, decade_truncate, and the world's gdp
--     DATE_PART('decade', CAST(year AS DATE)) AS decade,
--     DATE_TRUNC('decade', CAST(year AS DATE)) AS decade_truncated,
--     SUM(gdp) AS world_gdp
-- FROM country_stats
-- -- Group and order by year in descending order
-- GROUP BY year
-- ORDER BY year DESC;


-- -- Convert country to lower case
-- SELECT 
-- 	country, 
--     LOWER(country) AS country_altered
-- FROM countries
-- GROUP BY country;

-- -- Convert country to proper case
-- SELECT 
-- 	country, 
--     INITCAP(country) AS country_altered
-- FROM countries
-- GROUP BY country;

-- -- Output the left 3 characters of country
-- SELECT 
-- 	country, 
--     LEFT(country, 3) AS country_altered
-- FROM countries
-- GROUP BY country;

-- -- Output all characters starting with position 7
-- SELECT 
-- 	country, 
--     SUBSTRING(country,7) AS country_altered
-- FROM countries
-- GROUP BY country;



-- SELECT 
-- 	region, 
--     -- Replace all '&' characters with the string 'and'
--     REPLACE(region,'&','and') AS character_swap,
--     -- Remove all periods
--     REPLACE(region,'.','') AS character_remove,
--     -- Combine the functions to run both changes at once
--     REPLACE(REPLACE(region,'&','and'), '.','') AS character_swap_and_remove
-- FROM countries
-- WHERE region = 'LATIN AMER. & CARIB'
-- GROUP BY region;


-- -- Pull event and unique athletes from summer_games_messy 
-- SELECT 
--     -- Remove dashes from all event values
--     TRIM(REPLACE(event, '-', '')) AS event_fixed, 
--     COUNT(DISTINCT athlete_id) AS athletes
-- FROM summer_games_messy
-- -- Update the group by accordingly
-- GROUP BY event_fixed;


-- -- Show total gold_medals by country
-- SELECT 
-- 	country, 
--     SUM(gold) AS gold_medals
-- FROM winter_games AS w
-- JOIN countries AS c
-- ON w.country_id = c.id
-- -- Removes any row with no gold medals
-- WHERE gold IS NOT NULL
-- GROUP BY c.country
-- -- Order by gold_medals in descending order
-- ORDER BY gold_medals DESC;


-- -- Show total gold_medals by country
-- SELECT 
-- 	country, 
--     SUM(gold) AS gold_medals
-- FROM winter_games AS w
-- JOIN countries AS c
-- ON w.country_id = c.id
-- -- Comment out the WHERE statement
-- -- WHERE gold IS NOT NULL
-- GROUP BY country
-- -- Replace WHERE statement with equivalent HAVING statement
-- HAVING SUM(gold) IS NOT NULL
-- -- Order by gold_medals in descending order
-- ORDER BY gold_medals DESC;


/*TO CONVERT A NULL VALUE TO O, USE COALESCE*/
-- -- Pull events and golds by athlete_id for summer events
-- SELECT 
--     athlete_id, 
--     -- Replace all null gold values with 0
--     AVG(COALESCE(gold, '0')) AS avg_golds,
--     COUNT(event) AS total_events, 
--     SUM(gold) AS gold_medals
-- FROM summer_games
-- GROUP BY athlete_id
-- -- Order by total_events descending and athlete_id ascending
-- ORDER BY total_events DESC, athlete_id;



-- SELECT SUM(gold_medals) AS gold_medals
-- FROM
-- 	(SELECT 
--      	w.country_id, 
--      	SUM(gold) AS gold_medals, 
--      	AVG(gdp) AS avg_gdp
--     FROM winter_games AS w
--     JOIN country_stats AS c
--     -- Update the subquery to join on a second field
--     ON c.country_id = w.country_id AND w.year = CAST(c.year AS date)
--     GROUP BY w.country_id) AS subquery;


-- SELECT 
-- 	-- Clean the country field to only show country_code
--     LEFT(REPLACE(UPPER(TRIM(c.country)), '.', ''), 3) AS country_code,
--     -- Pull in pop_in_millions and medals_per_million 
-- 	pop_in_millions,
--     -- Add the three medal fields using one sum function
-- 	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
-- 	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
-- FROM summer_games AS s
-- JOIN countries AS c 
-- ON s.country_id = c.id
-- -- Update the newest join statement to remove duplication
-- JOIN country_stats AS cs 
-- ON s.country_id = cs.country_id AND s.year = CAST(cs.year AS date)
-- -- Filter out null populations
-- WHERE cs.pop_in_millions IS NOT NULL
-- GROUP BY c.country, pop_in_millions
-- -- Keep only the top 25 medals_per_million rows
-- ORDER BY medals_per_million DESC
-- LIMIT 25;