-- What are average, max, and min values in the data?
SELECT
    round(AVG(population)) AS avg_population,
    MAX(population) AS max_population,
    MIN(population) AS max_population
FROM
    countries;


-- What about those numbers per category in the data (using HAVING)?
SELECT
    name,
    population
FROM
    countries
GROUP BY
    name
HAVING
    population > (
        SELECT
            AVG(population)
        FROM
            countries
    );


-- What ways are there to group the data values that don’t exist yet (using CASE)?
-- I chose to look into immigration status (neg vs. pos) and fertility rate. 
SELECT
    CASE
        WHEN net_migrants > 0 THEN 'Positive Immigration'
        WHEN net_migrants < 0 THEN 'Negative Immigration'
        ELSE 'Status Que'
    END AS immigration_stat,
    count(*) AS num_countries,
    sum(net_migrants) AS total_migrants,
    cast(avg(fertility_rate) AS numeric (4, 3)) AS avg_fertility_rate
FROM
    countries
GROUP BY
    1
ORDER BY
    2 DESC;


-- Then I wanted to also look at world pop and pop_change 
SELECT
    CASE
        WHEN net_migrants > 0 THEN 'Positive Immigration'
        WHEN net_migrants < 0 THEN 'Negative Immigration'
        ELSE 'Status Que'
    END AS immigration_stat,
    CASE
        WHEN population_change > 0 THEN 'Positive Pop Change'
        WHEN population_change < 0 THEN 'Negative Pop Change'
        ELSE 'Status Que'
    END AS population_stat,
    count(*) AS num_countries,
    sum(net_migrants) AS total_migrants,
    sum(population_change) AS total_pop_change,
    cast(sum(percent_of_world_pop) AS numeric (4, 2)) AS sum_percent_of_world_pop,
    cast(avg(fertility_rate) AS numeric (4, 3)) AS avg_fertility_rate
FROM
    countries
GROUP BY
    1,
    2
ORDER BY
    3 DESC;


-- What interesting ways are there to filter the data (using AND/OR)?
-- Here I wanted to genral metrics about the counries with the lowest birth rates
SELECT
    name,
    population,
    net_migrants,
    population_change,
    fertility_rate,
    median_age,
    density_per_sq_km
FROM
    countries
WHERE
    fertility_rate < 2.5
    AND median_age BETWEEN 35
    AND 45
GROUP BY
    1
ORDER BY
    fertility_rate ASC;