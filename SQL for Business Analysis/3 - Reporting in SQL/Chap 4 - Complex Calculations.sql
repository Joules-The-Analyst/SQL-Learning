SELECT 
	country_id,
    year,
    gdp,
    -- Show max gdp for the table and alias accordingly
	MAX(gdp) OVER (PARTITION BY country_id) AS country_max_gdp
FROM country_stats;

SELECT 
	country_id,
    year,
    gdp,
    -- Show max gdp for the table and alias accordingly
	MAX(gdp) OVER () AS global_max_gdp
FROM country_stats;


-- -- Pull in avg_total_golds by region
-- SELECT 
-- 	region,
--     AVG(total_golds) AS avg_total_golds
-- FROM
--   (SELECT 
--       region, 
--       country_id, 
--       SUM(gold) AS total_golds
--   FROM summer_games_clean AS s
--   JOIN countries AS c
--   ON s.country_id = c.id
--   -- Alias the subquery
--   GROUP BY region, country_id) AS subquery
-- GROUP BY region
-- -- Order by avg_total_golds in descending order
-- ORDER BY avg_total_golds DESC;


-- -- Query region, athlete name, and total_golds
-- SELECT 
-- 	region,
--     athlete_name,
--     total_golds
-- FROM
--     (SELECT 
-- 		-- Query region, athlete_name, and total gold medals
--         region, 
--         name AS athlete_name, 
--         SUM(gold) AS total_golds,
--         -- Assign a regional rank to each athlete
--         ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(gold) DESC) AS row_num
--     FROM summer_games_clean AS s
--     JOIN athletes AS a
--     ON a.id = s.athlete_id
--     JOIN countries AS c
--     ON s.country_id = c.id
--     -- Alias as subquery
--     GROUP BY region, athlete_name) AS subquery
-- -- Filter for only the top athlete per region
-- WHERE row_num = 1;



-- Pull country_gdp by region and country
SELECT 
	region,
    country,
	SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    SUM(SUM(gdp)) OVER () AS global_gdp,
    -- Calculate percent of global gdp
    SUM(gdp) / SUM(SUM(gdp)) OVER () AS perc_global_gdp,
    -- Calculate percent of gdp relative to its region
    SUM(gdp) / SUM(SUM(gdp)) OVER (PARTITION BY region) AS perc_region_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;



-- Bring in region, country, and gdp_per_million
SELECT 
    region,
    country,
    SUM(gdp) / SUM(pop_in_millions) AS gdp_per_million,
    -- Output the worlds gdp_per_million
    SUM(SUM(gdp)) OVER () / SUM(SUM(pop_in_millions)) OVER () AS gdp_per_million_total,
    -- Build the performance_index 	
    (SUM(gdp)/SUM(pop_in_millions))   
      /    
    (SUM(SUM(gdp)) OVER () / SUM(SUM(pop_in_millions)) OVER ()) AS performance_index 
-- Pull from country_stats_clean
FROM country_stats_clean AS cs
JOIN countries AS c 
ON cs.country_id = c.id
-- Filter for 2016 and remove null gdp values
WHERE year = '2016-01-01' AND gdp IS NOT NULL
GROUP BY region, country
-- Show highest gdp_per_million at the top
ORDER BY gdp_per_million DESC;



SELECT
	-- Pull month and country_id
	DATE_PART('month', date) AS month,
	country_id,
    -- Pull in current month views
    SUM(views) AS month_views,
    -- Pull in last month views
    LAG(SUM(views)) OVER(PARTITION BY country_id ORDER BY DATE_PART('month', date)) AS previous_month_views,
    -- Calculate the percent change
    SUM(views) / LAG(SUM(views)) OVER(PARTITION BY country_id ORDER BY DATE_PART('month', date))-1 AS perc_change
FROM web_data
WHERE date <= '2018-05-31'
GROUP BY month, country_id;



SELECT 
  date,
  weekly_avg,
  LAG(weekly_avg, 7) OVER (ORDER BY date) AS weekly_avg_previous,
  (weekly_avg / LAG(weekly_avg, 7) OVER (ORDER BY date) - 1) AS perc_change
FROM (
  SELECT
    date,
    AVG(views) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
  FROM (
    SELECT
      date,
      SUM(views) AS views
    FROM web_data
    GROUP BY date
  ) AS daily_data
) AS subquery
ORDER BY date DESC;



SELECT
	-- Pull in region and calculate avg tallest height
    region,
    AVG(height) AS avg_tallest,
    -- Calculate region's percent of world gdp
    SUM(cs.gdp) / SUM(SUM(cs.gdp)) OVER () AS perc_world_gdp    
FROM countries AS c
JOIN
    (SELECT 
     	-- Pull in country_id and height
        country_id, 
        height, 
        -- Number the height of each country's athletes
        ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY height DESC) AS row_num
    FROM winter_games AS w 
    JOIN athletes AS a ON w.athlete_id = a.id
    GROUP BY country_id, height
    -- Alias as subquery
    ORDER BY country_id, height DESC) AS subquery
ON c.id = subquery.country_id
-- Join to country_stats
JOIN country_stats AS cs
ON cs.country_id = subquery.country_id
-- Only include the tallest height for each country
WHERE row_num = 1
GROUP BY region;