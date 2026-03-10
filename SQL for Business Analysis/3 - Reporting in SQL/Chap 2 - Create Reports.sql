-- -- Query season, country, and events for all summer events
-- SELECT 
-- 	'summer' AS season, 
--     country, 
--     COUNT(DISTINCT event) AS events
-- FROM summer_games AS s
-- JOIN countries AS c
-- ON s.country_id = c.id
-- GROUP BY country
-- -- Combine the queries
-- UNION ALL
-- -- Query season, country, and events for all winter events
-- SELECT 
-- 	'winter' AS season, 
--     country, 
--     COUNT(DISTINCT event) AS events
-- FROM winter_games AS w
-- JOIN countries AS c
-- ON w.country_id = c.id
-- GROUP BY country
-- -- Sort the results to show most events at the top
-- ORDER BY events DESC;


-- -- Add outer layer to pull season, country and unique events
-- SELECT 
-- 	season, 
--     country, 
--     COUNT(DISTINCT event) AS events
-- FROM
--     -- Pull season, country_id, and event for both seasons
--     (SELECT 
--      	'summer' AS season, 
--      	country_id, 
--      	event
--     FROM summer_games
--     UNION
--     SELECT 
--      	'winter' AS season, 
--      	country_id, 
--      	event
--     FROM winter_games) AS subquery
-- JOIN countries AS c
-- ON c.id = subquery.country_id
-- -- Group by any unaggregated fields
-- GROUP BY season, country
-- -- Order to show most events at the top
-- ORDER BY events DESC;



-- SELECT 
-- 	name,
--     -- Output 'Tall Female', 'Tall Male', or 'Other'
-- 	CASE WHEN height >= 175 AND gender = 'F' THEN 'Tall Female'
--     WHEN height >= 190 AND gender = 'M' THEN 'Tall Male'
--     Else 'Other' END AS segment
-- FROM athletes;


-- -- Pull in sport, bmi_bucket, and athletes
-- SELECT 
-- 	sport,
--     -- Bucket BMI in three groups: <.25, .25-.30, and >.30	
--     CASE WHEN (100*weight/height^2) < .25 THEN '<.25'
--     WHEN (100*weight/height^2) <= .30 THEN '.25-.30'
--     WHEN (100*weight/height^2) > .30 THEN '>.30' END AS bmi_bucket,
--     COUNT(DISTINCT athlete_id) AS athletes
-- FROM summer_games AS s
-- JOIN athletes AS a
-- ON a.id = s.athlete_id
-- -- GROUP BY non-aggregated fields
-- GROUP BY sport, bmi_bucket
-- -- Sort by sport and then by athletes in descending order
-- ORDER BY SPORT, athletes DESc;


-- -- Pull summer bronze_medals, silver_medals, and gold_medals
-- SELECT 
-- 	SUM(bronze) AS bronze_medals, 
--     SUM(silver) AS silver_medals, 
--     SUM(gold) AS gold_medals
-- FROM summer_games AS s
-- JOIN athletes AS a
-- ON s.athlete_id = a.id
-- -- Filter for athletes age 16 or below
-- WHERE age < 17;


-- -- Pull summer bronze_medals, silver_medals, and gold_medals
-- SELECT 
-- 	SUM(bronze) AS bronze_medals, 
--     SUM(silver) AS silver_medals, 
--     SUM(gold) AS gold_medals
-- FROM summer_games
-- -- Add the WHERE statement below
-- WHERE athlete_id IN
--     -- Create subquery list for athlete_ids age 16 or below    
--     (SELECT id
--      FROM athletes
--      WHERE age < 17);



-- -- Pull event and unique athletes from summer_games 
-- SELECT 
--     event,
--     -- Add the gender field below
--     CASE WHEN event LIKE '%Women%' THEN 'female' 
--     ELSE 'male' END AS gender,
--     COUNT(DISTINCT athlete_id) AS athletes
-- FROM summer_games
-- -- Only include countries that won a nobel prize
-- WHERE country_id IN 
-- 	(SELECT country_id 
--     FROM country_stats 
--     WHERE nobel_prize_winners > 0)
-- GROUP BY event
-- -- Add the second query below and combine with a UNION
-- UNION
-- SELECT 
--     event,
--     -- Add the gender field below
--     CASE WHEN event LIKE '%Women%' THEN 'female' 
--     ELSE 'male' END AS gender,
--     COUNT(DISTINCT athlete_id) AS athletes
-- FROM winter_games
-- -- Only include countries that won a nobel prize
-- WHERE country_id IN 
-- 	(SELECT country_id 
--     FROM country_stats 
--     WHERE nobel_prize_winners > 0)
-- GROUP BY event
-- -- Order and limit the final output
-- ORDER BY athletes DESC
-- LIMIT 10;