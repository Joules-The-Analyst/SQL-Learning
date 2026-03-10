-- -- -- INNER JOINS IN SQL
-- -- Select all columns from cities
-- SELECT *
-- FROM countries.cities

-- SELECT * 
-- FROM countries.cities
-- -- Inner join to countries
-- INNER JOIN countries.countries
-- -- Match on country codes
-- ON cities.country_code = countries.code

-- -- Select name fields (with alias) and region 
-- SELECT cities.name AS city, countries.name AS country, countries.region
-- FROM countries.cities
-- INNER JOIN countries.countries
-- ON cities.country_code = countries.code;

-- -- Select fields with aliases
-- SELECT c.code AS country_code, c.name, e.year, e.inflation_rate
-- FROM countries.countries AS c
-- -- Join to economies (alias e)
-- INNER JOIN countries.economies AS e
-- -- Match on code field using table aliases
-- ON c.code = e.code

-- SELECT c.name AS country, l.name AS language, official
-- FROM countries.countries AS c
-- INNER JOIN countries.languages AS l
-- -- Match using the code column
-- USING(code)


-- -- -- DEFINING A RELATIONSHIP IN SQL
-- -- Select country and language name (aliased)
-- SELECT c.name AS country, l.name AS language
-- -- From countries (aliased)
-- FROM countries.countries AS c
-- -- Join to languages (aliased)
-- INNER JOIN countries.languages AS l
-- -- Use code as the joining field with the USING keyword
-- USING(code)
-- -- Filter for the Bhojpuri language
-- WHERE l.name = 'Bhojpuri';


-- -- -- MULTIPLE JOINS
-- -- Select relevant fields
-- SELECT c.name, p.fertility_rate
-- FROM countries.countries AS c
-- -- Inner join countries and populations, aliased, on code
-- INNER JOIN countries.populations AS p
-- ON c.code = p.country_code

-- -- Select fields
-- SELECT c.name, e.year, p.fertility_rate, e.unemployment_rate
-- FROM countries.countries AS c
-- INNER JOIN countries.populations AS p
-- ON c.code = p.country_code
-- -- Join to economies (as e)
-- INNER JOIN countries.economies AS e
-- -- Match on country code
-- ON c.code = e.code;

-- SELECT name, e.year, fertility_rate, unemployment_rate
-- FROM countries.countries AS c
-- INNER JOIN countries.populations AS p
-- ON c.code = p.country_code
-- INNER JOIN countries.economies AS e
-- ON c.code = e.code
-- -- Add an additional joining condition such that you are also joining on year
-- 	AND p.year = e.year;


-- -- -- LEFT AND RIGHT OUTER JOIN
-- SELECT 
-- 	c1.name AS city, 
--     code, 
--     c2.name AS country,
--     region, 
--     city_proper_pop
-- FROM countries.cities AS c1
-- -- Join right table (with alias)
-- INNER JOIN countries.countries AS c2
-- ON c1.country_code = c2.code
-- ORDER BY code DESC;

-- SELECT 
-- 	c1.name AS city, 
--     code, 
--     c2.name AS country,
--     region, 
--     city_proper_pop
-- FROM countries.cities AS c1
-- -- Join right table (with alias)
-- LEFT JOIN countries.countries AS c2
-- ON c1.country_code = c2.code
-- ORDER BY code DESC;

-- SELECT name, region, gdp_percapita
-- FROM countries AS c
-- LEFT JOIN economies AS e
-- -- Match on code fields
-- USING(code)
-- -- Filter for the year 2010
-- WHERE year = 2010;

-- SELECT region, AVG(gdp_percapita) AS avg_gdp
-- FROM countries.countries AS c
-- LEFT JOIN countries.economies AS e
-- USING(code)
-- WHERE year = 2010
-- GROUP BY region
-- -- Order by descending avg_gdp
-- ORDER BY avg_gdp DESC
-- -- Return only first 10 records
-- LIMIT 10;

-- -- Modify this query to use RIGHT JOIN instead of LEFT JOIN
-- SELECT countries.name AS country, languages.name AS language, percent
-- FROM languages
-- RIGHT JOIN countries
-- USING(code)
-- ORDER BY language;


-- -- -- LEARNING OUTER JOIN
-- SELECT name AS country, code, region, basic_unit
-- FROM countries.countries
-- -- Join to currencies
-- FULL JOIN countries.currencies 
-- USING (code)
-- -- Where region is North America or name is null
-- WHERE region = 'North America' OR name IS NULL
-- ORDER BY region;

-- SELECT name AS country, code, region, basic_unit
-- FROM countries.countries
-- -- Join to currencies
-- LEFT JOIN countries.currencies
-- USING (code)
-- WHERE region = 'North America' 
-- 	OR name IS NULL
-- ORDER BY region;

-- SELECT name AS country, code, region, basic_unit
-- FROM countries.countries
-- -- Join to currencies
-- INNER JOIN countries.currencies 
-- USING (code)
-- WHERE region = 'North America' 
-- 	OR name IS NULL
-- ORDER BY region;

-- SELECT 
-- 	c1.name AS country, 
--     region, 
--     l.name AS language,
-- 	basic_unit, 
--     frac_unit
-- FROM countries.countries as c1 
-- -- Full join with languages (alias as l)
-- FULL JOIN countries.languages as l 
-- USING(code)
-- -- Full join with currencies (alias as c2)
-- FULL JOIN countries.currencies as c2
-- USING(code)
-- WHERE region LIKE 'M%esia';


-- -- -- CROSS-JOINS IN SQL
-- SELECT c.name AS country, l.name AS language
-- FROM countries.countries AS c
-- -- Inner join countries as c with languages as l on code
-- INNER JOIN countries.languages AS l
-- USING(code)
-- WHERE c.code IN ('PAK','IND')
-- 	AND l.code IN ('PAK','IND');

-- SELECT c.name AS country, l.name AS language
-- FROM countries.countries AS c        
-- -- Perform a cross join to languages (alias as l)
-- CROSS JOIN countries.languages AS l
-- WHERE c.code in ('PAK','IND')
-- 	AND l.code in ('PAK','IND');

-- SELECT 
-- 	c.name AS country,
--     region,
--     life_expectancy AS life_exp
-- FROM countries.countries AS c
-- -- Join to populations (alias as p) using an appropriate join
-- INNER JOIN countries.populations AS p 
-- ON c.code = p.country_code
-- -- Filter for only results in the year 2010
-- WHERE year = 2010
-- -- Sort by life_exp
-- ORDER BY  life_exp
-- -- Limit to five records
-- LIMIT 5;


-- -- -- SELF JOINS IN SQL
-- -- Select aliased fields from populations as p1
-- SELECT p1.country_code, p1.size AS size2010, p2.size AS size2015
-- -- Join populations as p1 to itself, alias as p2, on country code
-- FROM countries.populations AS p1
-- INNER JOIN countries.populations AS p2
-- USING(country_code)
	
-- SELECT 
-- 	p1.country_code, 
--     p1.size AS size2010, 
--     p2.size AS size2015
-- FROM countries.populations AS p1
-- INNER JOIN countries.populations AS p2
-- ON p1.country_code = p2.country_code
-- WHERE p1.year = 2010
-- -- Filter such that p1.year is always five years before p2.year
--     AND p2.year = p1.year + 5 


-- -- -- -- SET THEORY IN SQL
-- -- -- UNION AND UNION ALL
-- -- Select all fields from economies2015
-- SELECT *
-- FROM countries.economies2015    
-- -- Set operation
-- UNION
-- -- Select all fields from economies2019
-- SELECT *
-- FROM countries.economies2019
-- ORDER BY code, year;

-- -- Query that determines all pairs of code and year from economies and populations, without duplicates
-- SELECT code, year
-- FROM countries.economies
-- UNION 
-- SELECT country_code, year
-- FROM countries.countries.countries.populations
-- ORDER BY code, year

-- SELECT code, year
-- FROM countries.economies
-- -- Set theory clause
-- UNION ALL
-- SELECT country_code, year
-- FROM countries.populations
-- ORDER BY code, year;

-- -- -- INTERSECT IN SQL
-- -- Return all cities with the same name as a country
-- SELECT name
-- FROM countries.countries
-- INTERSECT
-- SELECT name
-- FROM countries.cities

-- -- -- EXCEPT IN SQL
-- -- Return all cities that do not have the same name as a country
-- SELECT name
-- FROM countries.cities
-- EXCEPT
-- SELECT name
-- FROM countries.countries
-- ORDER BY name;


-- -- -- -- SUBQUERIES IN SQL
-- -- SEMI JOINS IN SQL
-- -- Select country code for countries in the Middle East
-- SELECT code
-- FROM countries.countries
-- WHERE region = 'Middle East'

-- -- Select unique language names
-- SELECT DISTINCT(name)
-- FROM countries.languages
-- -- Order by the name of the language
-- ORDER BY name;

-- SELECT DISTINCT name
-- FROM countries.languages
-- -- Add syntax to use bracketed subquery below as a filter
-- WHERE code IN 
--     (SELECT code
--     FROM countries.countries
--     WHERE region = 'Middle East')
-- ORDER BY name;

-- -- ANTI JOINS IN SQL
-- -- Select code and name of countries from Oceania
-- SELECT code, name
-- FROM countries.countries
-- WHERE continent = 'Oceania'

-- SELECT code, name
-- FROM countries.countries
-- WHERE continent = 'Oceania'
-- -- Filter for countries not included in the bracketed subquery
--   AND code NOT IN 
--     (SELECT code
--     FROM countries.currencies);

-- -- -- SELECT AND WHERE CLAUSE SUBQUERIES
-- -- Select average life_expectancy from the populations table
-- SELECT AVG(life_expectancy)
-- FROM countries.populations
-- -- Filter for the year 2015
-- WHERE year = 2015

-- SELECT *
-- FROM countries.populations
-- WHERE year = 2015
-- -- Filter for only those populations where life expectancy is 1.15 times higher than average
--   AND life_expectancy > 1.15 *
--   (SELECT AVG(life_expectancy)
--    FROM countries.populations
--    WHERE year = 2015);

-- SELECT countries.name AS country, COUNT(*) AS cities_num
-- FROM countries.countries
-- LEFT JOIN countries.cities
-- ON countries.code = cities.country_code
-- GROUP BY country
-- ORDER BY cities_num DESC, country
-- LIMIT 9;

-- SELECT countries.name AS country,
-- -- Subquery that provides the count of cities   
--   (SELECT COUNT(*)
--    FROM countries.cities
--    WHERE countries.code = cities.country_code) AS cities_num
-- FROM countries.countries
-- ORDER BY cities_num DESC, country
-- LIMIT 9;

-- -- --FROM SUBQUERIES IN SQL
-- -- Select code, and language count as lang_num
-- SELECT code, COUNT(*) AS lang_num
-- FROM countries.languages
-- GROUP BY code

-- -- Select local_name and lang_num from appropriate tables
-- SELECT local_name, sub.lang_num
-- FROM countries.countries,
--     (SELECT code, COUNT(*) AS lang_num
--      FROM countries.languages
--      GROUP BY code) AS sub
-- -- Where codes match    
-- WHERE countries.countries.code = sub.code
-- ORDER BY lang_num DESC;

-- -- -- PRACTICING MY SKILS IN JOINS
-- -- Select relevant fields
-- SELECT code, inflation_rate, unemployment_rate
-- FROM countries.economies
-- WHERE year = 2015 
--   AND code IN
-- -- Subquery returning country codes filtered on gov_form
-- 	(SELECT code
--   FROM countries.countries
--   WHERE (gov_form LIKE '%Monarchy%' OR gov_form LIKE '%Republic%'))
-- ORDER BY inflation_rate;

-- -- Select fields from cities
-- SELECT name, country_code, city_proper_pop, metroarea_pop, (city_proper_pop / metroarea_pop * 100) AS city_perc 
-- -- Use subquery to filter city name
-- FROM countries.cities
-- WHERE name IN(
--     SELECT capital
--     FROM countries.countries
--     WHERE (continent = 'Europe' OR continent LIKE '%America'))
-- -- Add filter condition such that metroarea_pop does not have null values
--     AND metroarea_pop IS NOT NULL
-- -- Sort and limit the result
-- ORDER BY city_perc DESC
-- LIMIT 10