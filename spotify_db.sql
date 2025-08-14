DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
SELECT COUNT(*) FROM spotify;
SELECT COUNT(DISTINCT artist) FROM spotify;
SELECT DISTINCT album_type FROM spotify;
SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;
SELECT * FROM spotify
WHERE duration_min=0
DELETE FROM spotify 
WHERE duration_min=0;
SELECT * FROM spotify
WHERE duration_min=0
SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

-----------------------------------------
-- Data analysis - easy category--
-----------------------------------------
--1.Retrieve the names of all tracks that have more than 1 billion streams.
SELECT * FROM spotify WHERE stream>1000000000

--2.List all albums along with their respective artists.
SELECT album, artist FROM spotify;

--3.Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(comments)as total_comments
FROM spotify
WHERE licensed ='TRUE'

--4.Find all tracks that belong to the album type single.
SELECT * FROM spotify
where album_type='single'

--5. Count the total number of tracks by each artist.
SELECT 
  artist, count(*)as total_no_songs
FROM spotify
group by artist
order by 2

--6.Calculate the average danceability of tracks in each album.
select 
   album, avg(DISTINCT danceability) as avg_danceability
from spotify
group by 1
order by 2

--7.Find the top 5 tracks with the highest energy values.
select 
  track, max(energy)
  from spotify
  group by 1
  order by 2 desc
  limit 5

-- 8. List all tracks along with their views and likes where official_video = TRUE.
  select
  track,
  sum(views) as total_views,
  sum(likes) as total_likes
  from spotify
  where official_video= 'true'
  group by 1
  order by 2 desc

-- 9. For each album, calculate the total views of all associated tracks.
select album,track,
Sum(views) 
from spotify
group by 1 , 2
order by 3 desc

--10. Retrieve the track names that have been streamed on Spotify.
select 
track,
--most_played_on, 
COALESCE(sum(case when most_played_on ='Spotify' then Stream end),0) as Streamed_on_spotify
from spotify
group by 1
order by 2 desc

--11. find the top3 most-viewed tracks for each artist using window functions.
with ranking_artist
as
(select 
artist, 
track,
sum(views) as total_view,
dense_rank()over(partition by artist order by sum(views)desc) as rank
from spotify
group by 1,2
order by 1,3 desc
)
select * from ranking_artist
where rank <= 3

--12. write a query to find tracks where the liveness score is above the avg.

select
track,
artist,
liveness
from spotify
where liveness >(select avg(liveness) from spotify)

-- 13. use a with clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with cte
as 
(select
album, 
max(energy) as highest_energy,
MIN(energy) as lowest_energy
from spotify
group by 1
)
select 
album,
highest_energy - lowest_energy as energy_difference
from cte
order by 2 desc

-- 14. FIND tracks where the energy-to-liveness ratio is greater than 1.2.
with energy_liveness_ratio as (
select 
track,
energy / liveness  as ratio
from spotify
)
select track, ratio
from energy_liveness_ratio 
where ratio> 1.2;

--15. calculate the cumulative sum of likes track ordered by the number of views, using window function.

select 
track,
likes,
views,
sum(likes)over (order by views) as cumulative_likes
from spotify;



















































