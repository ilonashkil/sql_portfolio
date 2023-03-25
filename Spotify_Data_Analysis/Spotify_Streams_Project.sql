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


-- Which song had the highest popularity score by release year?
-- This query calculates the popularity score for each song based on a weighted combination of streams, valence, 
-- energy, and danceability. It then uses ROW_NUMBER() to rank the songs within each year based on their popularity 
-- score, and selects only the top-ranked song for each year.
WITH song_popularity AS (SELECT song,
                                artist,
                                release_date,
                                streams_billions,
                                (0.2 * s.streams_billions + 0.3 * f.valence + 0.1 * f.energy +
                                 0.1 * f.danceability)          AS popularity_score,
                                EXTRACT(YEAR FROM release_date) AS year
                         FROM spot_streams s
                                  JOIN spot_features f ON s.song = f.name),
     ranked_songs AS (SELECT song,
                             artist,
                             release_date,
                             streams_billions,
                             popularity_score,
                             year,
                             ROW_NUMBER() OVER (PARTITION BY year ORDER BY popularity_score DESC) AS rank
                      FROM song_popularity)
SELECT song,
       artist,
       streams_billions,
       popularity_score,
       year
FROM ranked_songs
WHERE rank = 1
ORDER BY year DESC;


-- Which songs with a danceability greater than 0.7 and a liveness greater than 0.5 have been streamed 
-- more than 500 million times?
SELECT s.artist, s.song, s.release_date, f.danceability, f.liveness, s.streams_billions
FROM spot_streams s
         JOIN spot_features f
              ON s.song = f.name
WHERE f.danceability >= 0.7
  AND f.liveness >= 0.5
  AND s.streams_billions >= 0.5
ORDER BY s.streams_billions DESC;


-- Basic stats: 
--- 1) Which song is longest and which is the shortest?
SELECT s.artist, f.name, f.duration
FROM spot_features f
         JOIN spot_streams s
              ON s.song = f.name
WHERE f.duration =
      (SELECT MAX(duration) FROM spot_features)
   OR f.duration =
      (SELECT MIN(duration) FROM spot_features);

--- 2) What song with a duration that equals to the average?
SELECT s.artist, f.name, f.duration
FROM spot_features f
         JOIN spot_streams s
              ON s.song = f.name
WHERE f.duration = (SELECT TRUNC(AVG(duration), 2) FROM spot_features);

--- 3) How many songs are longer than the average and how many are shorter?
SELECT COUNT(*) AS count,
       CASE
           WHEN duration < (SELECT TRUNC(AVG(duration), 2) FROM spot_features) THEN 'Below average'
           WHEN duration > (SELECT TRUNC(AVG(duration), 2) FROM spot_features) THEN 'Above average'
           ELSE 'Average'
           END  AS duration_groups
FROM spot_features
GROUP BY duration_groups;
    
