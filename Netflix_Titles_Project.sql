-- Which country produces the most content for Netflix?
SELECT country, COUNT(*)
FROM netflix_titles
GROUP BY country
HAVING COUNT(*) = (SELECT MAX(content_count)
                   FROM (SELECT COUNT(*) AS content_count
                         FROM netflix_titles
                         GROUP BY country) AS counts);

-- What is the most common rating for Netflix content?
SELECT rating, COUNT(*)
FROM netflix_titles
GROUP BY rating
HAVING COUNT(*) = (SELECT MAX(rating_count)
                   FROM (SELECT COUNT(*) AS rating_count
                         FROM netflix_titles
                         GROUP BY rating) AS counts)

-- How has the number of Netflix titles added per year changed over time?
ALTER TABLE netflix_titles
    ALTER COLUMN date_added TYPE DATE USING TO_DATE(date_added, 'Month DD, YYYY');

SELECT EXTRACT(YEAR FROM date_added) AS years, COUNT(*)
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY years
ORDER BY years;

--- TO BE CONTINUED --- 