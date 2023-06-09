-- Which country produces the most content for Netflix?
SELECT UNNEST(STRING_TO_ARRAY(country, ', ')) AS country_1, COUNT(*)
FROM netflix_titles
GROUP BY country_1
HAVING COUNT(*) = (SELECT MAX(content_count)
                   FROM (SELECT UNNEST(STRING_TO_ARRAY(country, ', ')) AS country_1, COUNT(*) AS content_count
                         FROM netflix_titles
                         GROUP BY country_1) AS counts);


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


-- Who are the top 10 most common directors for Netflix Movies?
SELECT director, COUNT(*) AS num_content
FROM netflix_titles
WHERE director IS NOT NULL
  AND type = 'Movie'
GROUP BY director
ORDER BY num_content DESC
LIMIT 10;


-- What are the most common genres for Netflix content - Movies vs TV Shows?
SELECT type, genre, num_content
FROM (SELECT type, UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre, COUNT(*) AS num_content
      FROM netflix_titles
      WHERE type IN ('Movie', 'TV Show')
        AND listed_in != ''
      GROUP BY type, genre) subquery
      -- This subquery calculates the count of each genre for each type, using the string_to_array() function to split 
      -- the listed_in column into an array of genres, and the unnest() function to expand the array into separate rows for each genre.
         JOIN (SELECT type AS max_type, MAX(num_content) AS max_num_content
               FROM (SELECT type, UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre, COUNT(*) AS num_content
                     FROM netflix_titles
                     WHERE type IN ('Movie', 'TV Show')
                       AND listed_in != ''
                     GROUP BY type, genre) max_subquery
               GROUP BY type) max_counts
              ON subquery.type = max_counts.max_type AND subquery.num_content = max_counts.max_num_content
ORDER BY type, num_content DESC;


-- Top 3 genres per type
-- This query first calculates the count of each genre for each type, as before, but then ranks the genres for each type 
-- using the ROW_NUMBER() function. Finally, it selects only the top 3 genres for each type by filtering on genre_rank <= 3.
SELECT type, genre, num_content
FROM (SELECT type,
             UNNEST(STRING_TO_ARRAY(listed_in, ', '))                     AS genre,
             COUNT(*)                                                     AS num_content,
             ROW_NUMBER() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS genre_rank
      FROM netflix_titles
      WHERE type IN ('Movie', 'TV Show')
        AND listed_in != ''
      GROUP BY type, genre) ranked_genres
WHERE genre_rank <= 3
ORDER BY type, num_content DESC;


-- What is the average duration of a Netflix movie versus a TV show?
-- This SQL query adds two new columns to the table netflix_titles to store the duration of movies in minutes and
-- the number of seasons for TV shows as integers. It uses regular expressions to extract the numeric values from
-- the `duration` column by removing any non-numeric characters, and then casts the resulting strings to integers.
ALTER TABLE netflix_titles
    ADD COLUMN num_seasons      INTEGER,
    ADD COLUMN duration_minutes INTEGER;

UPDATE netflix_titles
SET num_seasons      = CASE
                           WHEN type = 'TV Show' THEN CAST(REGEXP_REPLACE(duration, '[^0-9]+', '', 'g') AS INTEGER)
                           ELSE NULL
    END,
    duration_minutes = CASE
                           WHEN type = 'Movie' THEN CAST(REGEXP_REPLACE(duration, '[^0-9]+', '', 'g') AS INTEGER)
                           ELSE NULL
        END;

SELECT type,
       CAST(AVG(num_seasons) AS numeric(4, 2))      AS avg_seasons,
       CAST(AVG(duration_minutes) AS numeric(4, 2)) AS avg_minutes
FROM netflix_titles
GROUP BY type;


-- What is the trend in the number of movies versus TV shows added to Netflix over time?
SELECT type, EXTRACT(YEAR FROM date_added) AS years, COUNT(*)
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY type, years
ORDER BY type, years;


-- How many Netflix titles have a title or description that mentions a specific keyword?
-- Keyword groups
SELECT CASE
           WHEN description LIKE '%coming of age%' OR description LIKE '%crime%' OR description LIKE '%family dynamics%'
               THEN 'Theme keywords'
           WHEN description LIKE '%New York City%' OR description LIKE '%outer space%' OR description LIKE '%medieval Europe%'
               THEN 'Setting keywords'
            WHEN description LIKE '%inequality%' OR description LIKE '%climate change%' OR description LIKE '%addiction%'
               THEN 'Social issue keywords'
           ELSE 'other'
           END  AS keyword_groups,
       COUNT(*) AS count
FROM netflix_titles
GROUP BY keyword_groups
ORDER BY count ASC;

-- boys vs men vs girls vs women
SELECT CASE
           WHEN description ~* '\y(girls?|woman|women)\y' OR title ~* '\y(girls?|woman|women)\y' THEN 'girl/woman'
           WHEN description ~* '\y(boys?|man|men)\y' OR title ~* '\y(boys?|man|men)\y' THEN 'boy/man'
           ELSE 'other'
           END  AS gender_group,
       COUNT(*) AS count
FROM netflix_titles
GROUP BY gender_group
ORDER BY count ASC;


-- What are the most popular countries for producing content in a specific genre, and how has this changed over time?
SELECT UNNEST(STRING_TO_ARRAY(country, ', ')) AS country_1, release_year, COUNT(*) AS count
FROM (SELECT show_id, country, release_year, UNNEST(STRING_TO_ARRAY(listed_in, ', ')) AS genre
      FROM netflix_titles) AS t
WHERE genre = 'Comedies'
  AND country IS NOT NULL
GROUP BY country_1, release_year
ORDER BY country_1 DESC, release_year DESC;

SELECT EXTRACT(YEAR FROM start_time) AS year, content_type, SUM(duration), SUM(duration_hours)
FROM viewing_activity
WHERE profile_name = 'ilona'
GROUP BY year, content_type
ORDER BY content_type, year;

ALTER TABLE viewing_activity
    ADD COLUMN duration_hours NUMERIC;

UPDATE viewing_activity
SET duration_hours = (EXTRACT(HOUR FROM duration) * 3600
    + EXTRACT(MINUTE FROM duration) * 60
    + EXTRACT(SECOND FROM duration)) / 3600 * 1.0;