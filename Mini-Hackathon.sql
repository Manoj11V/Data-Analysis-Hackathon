/* Here i used -1 to represent the null Values*/
describe imdb_top;
Create database IMDB;
alter table imdb_top
modify gross int;
select * from imdb_top;
/*Analyze how movies directed by different directors perform in terms of gross earnings.
 Are there any noticeable trends or patterns?*/

-- Sum of Gross for the movies directed by Directors
select distinct	Director , sum(Gross) over (partition by Director ) as Sum_gross,count(Gross) over (partition by Director) as movie_count
from imdb_1000
where Gross !=-1
order by movie_count desc;
select distinct	Director , sum(Gross) over (partition by Director ) as Sum_gross,count(Gross) over (partition by Director) as movie_count
from imdb_1000
where Gross !=-1
order by sum_gross desc;
-- Average of gross for the movies 
select distinct	Director , sum(Gross) over (partition by Director )/count(Gross) over (partition by Director) as Average_gross
from imdb_1000
where Gross !=-1
order by Average_gross desc;
/*Yeah!.
Consider the example where 
       Anthony russo sum of total grosses movie  and total movie are '2205039403'-'4'
       Whereas Christopher Nolan directed 8 movies but total gross is '1937454106'*/



/*Investigate how different genres have evolved in popularity over time.*/

select Genre,
		case 
        when Released_Year <1930 then "1920's films"  
        when Released_Year between 1930 and 1950 then "1930-1950"
        when Released_Year between 1951 and 1970 then "1951-1970"
        when Released_Year between 1971 and 2000 then "1971-2000"
        when Released_year between 2000 and 2019 then "2K Films"
        end as Over_time ,avg(IMDB_Rating) as Imdb_Popularity,round(Avg(Meta_score),1) as Metascore_average
from imdb_1000
where Gross!=-1 and Meta_score !=-1
group by Genre,Released_year
order by Released_Year,Imdb_Popularity;


/*Explore if there's a relationship between a movie's IMDB rating and its box office earnings.*/
select 
    (sum((IMDB_Rating - avg_IMDB_Rating) * (gross - avg_gross)) / count(*)) /
    (sqrt(sum(pow(IMDB_Rating - avg_IMDB_Rating, 2)) / count(*)) *
     sqrt(sum(pow(gross - avg_gross, 2)) / count(*))) as correlation
from 
(select IMDB_Rating, gross, 
	(select avg(IMDB_Rating) from imdb_top) as avg_IMDB_Rating, 
	(select avg(gross) from imdb_top) as avg_gross
from imdb_top) as subquery;

-- The correlation nears to 0 have no linear relation between IMDB_rating and Box office

/* Examine whether the duration of a movie influences its ratings or financial success.
*/
select Runtime ,Round(avg(gross),2)as Average_gross ,Round(avg(imdb_rating),2) as Average_IMDB_RATING from imdb_1000
where gross!=-1
group by Runtime
order by Runtime ;
/*Mostly No.Because,Similar time length movies has different IMDB_ratings and different grosss*/



/*Analyze how the presence of certain actors correlates with a
 movie's performance in terms of ratings and earnings.*/
 select star1 ,round(avg(imdb_rating),2) as average_imdb_ratings
 from imdb_top
 where gross!=-1
 group by star1
 order by average_imdb_ratings desc;
 /*Stars do influence the ratings*/
 
 
 /*Study the impact of a movie's release date (e.g., month, season) on its success.
*/
/*It doesn't have required data find movie success based on the season .It has only year.
Only based on year it is hard to predict the festival seasons*/
