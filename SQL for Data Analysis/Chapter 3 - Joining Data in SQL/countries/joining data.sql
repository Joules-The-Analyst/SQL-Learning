-- -- -- INNER JOINS IN SQL
-- -- Select all columns from cities
-- SELECT *
-- FROM cities

-- SELECT * 
-- FROM cities
-- -- Inner join to countries
-- INNER JOIN countries
-- -- Match on country codes
-- ON cities.country_code = countries.code

-- -- Select name fields (with alias) and region 
-- SELECT cities.name AS city, countries.name AS country, countries.region
-- FROM cities
-- INNER JOIN countries
-- ON cities.country_code = countries.code;

-- -- Select fields with aliases
-- SELECT c.code AS country_code, c.name, e.year, e.inflation_rate
-- FROM countries AS c
-- -- Join to economies (alias e)
-- INNER JOIN economies AS e
-- -- Match on code field using table aliases
-- ON c.code = e.code

-- SELECT c.name AS country, l.name AS language, official
-- FROM countries AS c
-- INNER JOIN languages AS l
-- -- Match using the code column
-- USING(code)


-- -- DEFINING A RELATIONSHIP IN SQL
-- Select country and language name (aliased)
SELECT c.name AS country, l.name AS language
-- From countries (aliased)
FROM countries AS c
-- Join to languages (aliased)
INNER JOIN languages AS l
-- Use code as the joining field with the USING keyword
USING(code)
-- Filter for the Bhojpuri language
WHERE l.name = 'Bhojpuri';

