--Queryout the average runs scored by players on each ground.

SELECT ground, player, ROUND(AVG(runs),2)
FROM world_cup
WHERE bat_or_bowl = 'bat'
GROUP BY 1,2
ORDER BY 1,3 DESC
-- Sort the bowlers on the basis of good economy (Top 10 only).

SELECT player, AVG(econ)
FROM world_cup
WHERE bat_or_bowl = 'bowl'
GROUP BY 1
ORDER BY 2 ASC
LIMIT 10


--Find out the total wickets taken by the teams(DONE)
SELECT team, SUM(wkt)AS Total_wickets_Taken
FROM world_cup
WHERE bat_or_bowl = 'bowl'
GROUP BY 1
ORDER BY 2 DESC


--The total runs scored by each the teams(DONE)
SELECT team, SUM(runs) AS Total_Runs_Scored
FROM world_cup
WHERE bat_or_bowl = 'bat'
GROUP BY 1
ORDER BY 2 DESC


--Highest wicket taking playes in every teams
WITH cte AS(
		SELECT team, player,SUM(wkt) AS total_wicket,
		RANK() OVER(PARTITION BY team ORDER BY SUM(wkt) DESC) AS rnk
		FROM world_cup
		WHERE bat_or_bowl = 'bowl'
		GROUP BY 1,2
)
SELECT team,player,total_wicket
FROM cte
WHERE rnk = 1
			--OR--
SELECT team, player, total_wicket
FROM(
	SELECT team, player,SUM(wkt) AS total_wicket,
	RANK() OVER(PARTITION BY team ORDER BY SUM(wkt) DESC) AS rnk
	FROM world_cup
	WHERE bat_or_bowl = 'bowl'
	GROUP BY 1,2
	) AS abcd
WHERE rnk = 1

--Find out the highest run scored by a player in each team(DONE)
WITH cte AS(
		SELECT team, player,SUM(runs) AS total_runs,
		RANK() OVER(PARTITION BY team ORDER BY SUM(runs) DESC) AS rnk
		FROM world_cup
		WHERE bat_or_bowl = 'bat'
		GROUP BY 1,2
)
SELECT team,player,total_runs
FROM cte
WHERE rnk = 1
		--OR--
SELECT team, player, total_runs
FROM (
		SELECT team, player,SUM(runs) AS total_runs,
		RANK() OVER(PARTITION BY team ORDER BY SUM(runs) DESC) AS rnk
		FROM world_cup
		WHERE bat_or_bowl = 'bat'
		GROUP BY 1,2
) AS abcd
WHERE rnk = 1

--Batters who have achieved a century of runs
SELECT player, COUNT(runs)
FROM world_cup
WHERE bat_or_bowl = 'bat'
AND runs BETWEEN 100 AND 199
GROUP BY 1
ORDER BY 2 DESC

--Batters who have reached a half century
SELECT player, COUNT(runs)
FROM world_cup
WHERE bat_or_bowl = 'bat'
AND runs BETWEEN 50 AND 99
GROUP BY 1
ORDER BY 2 DESC

--Top 5 wicket taking bowlers throughout the tournament.(DONE)
SELECT player,SUM(wkt)
FROM world_cup
WHERE wkt IS NOT NULL
GROUP BY player 
ORDER BY 2 DESC
LIMIT 5
		--OR--
SELECT player AS Bowler_name,SUM(wkt) Total_wickets
FROM world_cup
WHERE bat_or_bowl = 'bowl'
GROUP BY player 
ORDER BY 2 DESC
LIMIT 5

--Top 5 best performing batters through out the world cup (DONE)
SELECT player AS Batter_name, SUM(runs) AS Total_runs
FROM world_cup
WHERE bat_or_bowl = 'bat'
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5

--How many players have played in the world cup 2023.
SELECT bat_or_bowl, COUNT(bat_or_bowl)
FROM world_cup 
GROUP BY bat_or_bowl

--Create a best team in world cup !
(SELECT player, SUM(runs), 'Batsman' AS Roles
FROM world_cup
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 6) 
UNION
(SELECT player,SUM(wkt), 'Bowler' AS Roles
FROM world_cup
WHERE bat_or_bowl = 'bowl'
GROUP BY player 
ORDER BY 2 DESC
LIMIT 5)
ORDER BY Roles

