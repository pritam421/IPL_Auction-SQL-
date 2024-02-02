select * from ipl_matches
select * from ipl_ball
-----------------------------------------------
/*
Your first priority is to get 2-3 players with high S.R who have faced at least 500 balls.And to 
do that you have to make a list of 10 players you want to bid in the auction so that when 
you try to grab them in auction you should not pay the amount greater than you have 
in the purse for a particular player.
*/

SELECT b.batsman, SUM(b.batsman_runs) AS total_runs, COUNT(*) AS balls_faced, (SUM(b.batsman_runs) / COUNT(*)) * 100 
AS strike_rate
FROM ipl_ball AS b
JOIN ipl_matches AS m ON b.id = m.id 
GROUP BY b.batsman
HAVING COUNT(*) >= 500
ORDER BY strike_rate DESC
LIMIT 10;

/* 
Now you need to get 2-3 players with good Average who have played more the 2 ipl seasons.
And to do that you have to make a list of 10 players you want to bid in the auction so that when you try to grab them 
in auction you should not pay the amount greater than you have in the purse for a particular player.
*/ 

SELECT batsman, round(AVG(matches_played),2) AS avg_matches_played
FROM (
  SELECT joined_data.batsman, COUNT(*) AS matches_played
  FROM (
    SELECT b.batsman, m.match_date
    FROM ipl_ball AS b
    JOIN ipl_matches AS m ON b.id = m.id
  ) AS joined_data
  GROUP BY joined_data.batsman
) AS player_matches
GROUP BY player_matches.batsman 
order by avg_matches_played desc 
limit 10;

/*
Now you need to get 2-3 Hard-hitting players who have scored most runs in boundaries and have played more 
the 2 ipl season. To do that you have to make a list of 10 players you want to bid in the auction so that when you 
try to grab them in auction you should not pay the amount greater than you have in the purse for a particular player.
*/
select a.batsman,
sum(a.batsman_runs) as total_runs,
sum(case when a.batsman_runs=4 then 1 else 0 end) as four,
sum(case when a.batsman_runs=6 then 1 else 0 end) as sixes,
(sum(case when a.batsman_runs=4 then 1 else 0 end)*4+
sum(case when a.batsman_runs=6 then 1 else 0 end)*6) as bounderies
from ipl_ball as a
join ipl_matches as b
on a.id =b.id
group by batsman
having count(distinct extract(year from b.match_date))>2
order by bounderies desc limit 10;

/*
Your first priority is to get 2-3 bowlers with good economy who have bowled at least 500 balls in IPL so far.
To do that you have to make a list of 10 players you want to bid in the auction so that when you try to grab them in 
auction you should not pay the amount greater than you have in the purse for a particular player.
*/
select b.bowler,round(b.total_runs/(total_balls/6.0),3) as economy_bowler
from (select bowler,sum(total_runs) as total_runs,
	 count(ball) as total_balls
	 from ipl_ball group by bowler) as b 
	 where total_balls >=500
	 order by economy_bowler limit 10;
/*
Now you need to get 2-3 bowlers with the best strike rate and who have bowled at least 500 balls in IPL so far.
To do that you have to make a list of 10 players you want to bid in the auction so that when you try to grab them in 
auction you should not pay the amount greater than you have in the purse for a particular player.
*/
select a.bowler,(a.total_runs/(total_balls/6.0)) as economy_bowler,a.total_wickets,(a.total_balls/(a.total_wickets*1.0)) 
as strike_rate
from (select bowler,sum(total_runs) as total_runs,sum(case when is_wicket=1 then 1 else 0 end) as total_wickets,
	 count(ball) as total_balls
	 from ipl_ball group by bowler) as a
	 where total_balls >=500 order by strike_rate desc limit 10;

/*
Now you need to get 2-3 All_rounders with the best batting as well as bowling strike rate and who have faced at least 
500 balls in IPL so far and have bowled minimum 300 balls.To do that you have to make a list of 10 players you want 
to bid in the auction so that when you try to grab them in auction you should not pay the amount greater than you have 
in the purse for a particular player.
*/

------------------------------------------------------------------------------------------
WITH BattingCTE AS (
    SELECT
        batsman,
        (SUM(batsman_runs) / COUNT(ball)) * 100 AS strike_rate
    FROM
        ipl_ball
    GROUP BY
        batsman
    HAVING
        COUNT(ball) >= 500),
BallingCTE AS (
    SELECT
        bowler,
        (COUNT(ball) * 1.0 / SUM(CASE WHEN is_wicket = 1 THEN 1 ELSE 0 END)) AS strike_ball_rate
    FROM
        ipl_ball
    GROUP BY
        bowler
    HAVING
        COUNT(ball) >= 500)
SELECT
    BattingCTE.batsman,
    BallingCTE.bowler,
    BattingCTE.strike_rate,
    BallingCTE.strike_ball_rate
FROM
    BattingCTE
JOIN
    BallingCTE ON BattingCTE.batsman = BallingCTE.bowler
LIMIT 10;

---------------------------------------------------------------------------------------

-- Additonal questions--

-- 1. Get the count of cities that have hosted an IPL match
select count(distinct city) as city_count from ipl_matches

/*
2.Create table deliveries_v02 with all the columns of the table ‘deliveries’ and an additional column ball_result containing 
values boundary, dot or other depending on the total_run (boundary for >= 4, dot for 0 and other for any other number)
(Hint 1 : CASE WHEN statement is used to get condition based results)
(Hint 2: To convert the output data of the select statement into a table, you can use a subquery. Create table table_name 
as [entire select statement].
*/

create table deliveries_v02 as select *,  
    CASE WHEN total_runs >= 4 then 'boundary'  
         WHEN total_runs = 0 THEN 'dot' 
   else 'other' 
     END as ball_result  
   FROM ipl_ball; 
select * from deliveries_v02

-- Write a query to fetch the total number of boundaries and dot balls from the deliveries_v02 table.
select ball_result, count (*) from deliveries_v02 group by ball_result; 

/* Write a query to fetch the total number of boundaries scored by each team from the deliveries_v02 table and order 
it in descending order of the number of boundaries scored.
*/

select batting_team, count(*) from deliveries_v02 where ball_result = 'boundary' group by batting_team order by count desc; 

/* Write a query to fetch the total number of dot balls bowled by each team and order it in descending order of the 
total number of dot balls bowled.
*/
select bowling_team, count(*) from deliveries_v02 where ball_result = 'dot' group by bowling_team order by count desc; 

--Write a query to fetch the total number of dismissals by dismissal kinds where dismissal kind is not NA
select dismissal_kind, count (*) from deliveries where dismissal_kind <> 'NA' group by dismissal_kind order by count desc; 

-- Write a query to get the top 5 bowlers who conceded maximum extra runs from the deliveries table
select bowler, sum(extra_runs) as total_extra_runs from deliveries group by bowler order by total_extra_runs desc limit 5; 

/* Write a query to create a table named deliveries_v03 with all the columns of deliveries_v02 table and two additional 
column (named venue and match_date) of venue and date from table matches
*/
select * from ipl_matches
create table  deliveries_v03 AS SELECT a.*, b.venue, b.match_date from  
deliveries_v02 as a  
left join (select max(venue) as venue, max(match_date) as match_date, id from ipl_matches group by id) as b 
on a.id = b.id; 
select * from deliveries_v03;

-- Write a query to fetch the total runs scored for each venue and order it in the descending order of total runs scored.
select venue, sum(total_runs) as runs from deliveries_v03 group by venue order by runs desc; 

--Write a query to fetch the year-wise total runs scored at Eden Gardens and order it in the descending order of total 
--runs scored.

select extract(year from match_date) as IPL_year, sum(total_runs) as total_runs_year from  deliveries_v03  
where venue = 'Eden Gardens' group by IPL_year order by total_runs_year desc; 










