-- Convering the Date column from text to date
ALTER TABLE spot_streams
    ALTER COLUMN release_date TYPE DATE
        USING TO_DATE(release_date, 'DD/MM/YYYY');


-- Which songs and artists have the highest total number of streams?
-- top streamed song
SELECT song, artist, streams_billions
FROM spot_streams
WHERE streams_billions = (SELECT MAX(streams_billions) FROM spot_streams);


-- top streamed artist
SELECT artist, SUM(streams_billions) as total_streams
FROM spot_streams
GROUP BY artist
HAVING SUM(streams_billions) = (
    SELECT MAX(total_streams) as max_streams
    FROM (
        SELECT SUM(streams_billions) as total_streams
        FROM spot_streams
        GROUP BY artist
    ) as artist_streams
);


-- Which songs/artists have the highest average number of streams per day since their release?
-- this query present all artists (without any combinations) and the average streams per day (in millions)
-- since their release day until today.
SELECT UNNEST(REGEXP_SPLIT_TO_ARRAY(artist, '\s+(and|with|featuring|&)\s+'))               AS artist_separated,
       CAST(AVG(streams_billions / (CURRENT_DATE - release_date)) * 1000 AS numeric(4, 2)) AS avg_streams_millions
FROM spot_streams
GROUP BY artist_separated
ORDER BY avg_streams_millions DESC;

-- only top 5
-- This query calculates the average number of streams per day for each artist by splitting the artist column
-- using regular expressions to handle multiple delimiters. It then groups the results by artist and sorts them
-- in descending order by the average number of streams per day. The ROW_NUMBER() function is used to rank the
-- artists, and the results are filtered to show only the top 5.
WITH artist_streams AS (
    SELECT UNNEST(regexp_split_to_array(artist, '\s+(and|with|featuring|&)\s+')) AS artist_separated,
           cast(AVG(streams_billions / (CURRENT_DATE - release_date)) * 1000 AS numeric(4, 2)) AS avg_streams_millions
    FROM spot_streams
    GROUP BY artist_separated
)
SELECT artist_separated, avg_streams_millions
FROM (
    SELECT artist_separated, avg_streams_millions,
           ROW_NUMBER() OVER (ORDER BY avg_streams_millions DESC) AS artist_rank
    FROM artist_streams
) ranked_artists
WHERE artist_rank <= 5
ORDER BY avg_streams_millions DESC;
