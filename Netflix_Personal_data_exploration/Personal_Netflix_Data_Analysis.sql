--- cleaning the data and preparing the table for exploration
--- creating separate columns for tv shows names, seasons and episodes
ALTER TABLE viewing_activity
    ADD COLUMN tv_show_name TEXT;
ALTER TABLE viewing_activity
    ADD COLUMN tv_show_season TEXT;
ALTER TABLE viewing_activity
    ADD COLUMN tv_show_episode TEXT;

UPDATE viewing_activity
SET tv_show_name    = SPLIT_PART(REPLACE(title, ':', '.'), '.', 1),
    tv_show_season  = SPLIT_PART(REPLACE(title, ':', '.'), '.', 2),
    tv_show_episode = SPLIT_PART(REPLACE(title, ':', '.'), '.', 3)
WHERE title LIKE '%:%:%';

--- creating a column for data type
ALTER TABLE viewing_activity
    ADD COLUMN content_type text;

UPDATE viewing_activity
SET content_type = CASE
                       WHEN tv_show_name IS NULL THEN 'movie'
                       ELSE 'tv show'
    END;

--- converting the duration data from text to interval to allow future calculations
ALTER TABLE viewing_activity
    ALTER COLUMN duration TYPE INTERVAL USING (duration::INTERVAL);

--- converting the start time from text to time stamp
UPDATE viewing_activity
SET start_time = TO_TIMESTAMP(start_time, 'DD/MM/YYYY HH24:MI');

--- what is the most watched tv-show?
SELECT tv_show_name, COUNT(*)
FROM viewing_activity
GROUP BY tv_show_name
HAVING COUNT(*) = (SELECT MAX(tv_show_name_count)
                   FROM (SELECT COUNT(*) AS tv_show_name_count
                         FROM viewing_activity
                         GROUP BY tv_show_name) AS counts);

--- by view count and profile
SELECT profile_name, tv_show_name, view_count
FROM (SELECT profile_name,
             tv_show_name,
             COUNT(*)                                                             AS view_count,
             ROW_NUMBER() OVER (PARTITION BY profile_name ORDER BY COUNT(*) DESC) AS rn
      FROM viewing_activity
      WHERE tv_show_name IS NOT NULL
      GROUP BY profile_name, tv_show_name) subquery
WHERE rn = 1;

--- by duration time and profile
SELECT profile_name, tv_show_name, view_duration
FROM (SELECT profile_name,
             tv_show_name,
             SUM(duration)                                                             AS view_duration,
             ROW_NUMBER() OVER (PARTITION BY profile_name ORDER BY SUM(duration) DESC) AS rn
      FROM viewing_activity
      WHERE tv_show_name IS NOT NULL
      GROUP BY profile_name, tv_show_name) subquery
WHERE rn = 1;