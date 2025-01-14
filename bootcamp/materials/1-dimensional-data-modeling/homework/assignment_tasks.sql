-- 1. Create the actors table.

-- Films 
-- ===========================

create type films as (
	year INTEGER,
	film varchar,
	votes INTEGER,
	rating real,
	filmid varchar
);

--drop type films cascade;

-- quality_class
-- ===========================

create type quality_class as ENUM('star','good','average','bad');

-- actor table
-- ===========================

create table actors (
	films films[],
	quality_class quality_class,
	is_active bool	
)


--drop table actors;

-- 2. Populate actos table one year at a time. 

select * from actor_films;
select * from actors;

select min(year), max(year) from actor_films;


with 
	prev_year as (select * from actor_films where year = '1971'),
	curr_year as (select * from actors where year = '1972')
select 
	coalesce (p.actor, c.actor) as actor, 
	coalesce (p.actorid, c.actorid) as actorid, 
	case when p.film is null then array[ROW(
		c.film, c.votes, c.rating, c.actorid)::films]
	else p.film || array[ROW(
		c.film, c.votes, c.rating, c.actorid)::films]
	end 
from prev_year p full outer join curr_year c
	on p.actorid = c.actorid and p.filmid = c.filmid;



--film, votes,  rating, filmid,
case when rating > 8 then 'star'
	when rating > 7 and rating <= 8 then 'good'
	when rating > 6 and rating <= 7 then 'average'
	when rating <= 6 then 'bad'
end as quality::quality_class
from actor_films




