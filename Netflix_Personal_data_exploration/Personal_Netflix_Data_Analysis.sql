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
UPDATE viewing_activity
SET duration = CAST(duration AS INTERVAL)
WHERE duration IS NOT NULL;

--- converting the start time from text to time stamp
UPDATE viewing_activity
SET start_time = TO_TIMESTAMP(start_time, 'DD/MM/YYYY HH24:MI');
