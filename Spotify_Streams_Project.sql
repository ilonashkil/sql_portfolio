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
