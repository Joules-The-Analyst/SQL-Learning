-- -- Query the sport and distinct number of athletes
-- SELECT 
-- 	sport, 
--     COUNT(DISTINCT athlete_id) AS athletes
-- FROM summer_games
-- GROUP BY sport
-- -- Only include the 3 sports with the most athletes
-- ORDER BY sport DESC
-- LIMIT 3;


-- -- Select the age of the oldest athlete for each region
-- SELECT 
-- 	region, 
--     MAX(age) AS age_of_oldest_athlete
-- FROM athletes AS a
-- -- First JOIN statement
-- JOIN summer_games AS s
-- ON a.id = s.athlete_id
-- -- Second JOIN statement
-- JOIN countries AS c
-- ON s.country_id = c.id
-- GROUP BY region;


-- -- Select sport and events for summer sports
-- SELECT 
-- 	sport, 
--     COUNT(DISTINCT event) AS events
-- FROM summer_games
-- GROUP BY sport
-- UNION
-- -- Select sport and events for winter sports
-- SELECT 
-- 	sport, 
--     COUNT(DISTINCT event) AS events
-- FROM winter_games
-- GROUP BY sport
-- -- Show the most events at the top of the report
-- ORDER BY events DESC;


-- -- Pull athlete_name and gold_medals for summer games
-- SELECT 
-- 	a.name AS athlete_name, 
--     SUM(s.gold) AS gold_medals
-- FROM summer_games AS s
-- JOIN athletes AS a
-- ON a.id = s.athlete_id
-- GROUP BY name
-- -- Filter for only athletes with 3 gold medals or more
-- HAVING SUM(gold) > 2
-- -- Sort to show the most gold medals at the top
-- ORDER BY gold_medals;