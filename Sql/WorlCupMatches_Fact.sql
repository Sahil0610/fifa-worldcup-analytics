CREATE DATABASE FIFAWorldCupAnalytics;

USE FIFAWorldCupAnalytics;

DROP TABLE IF EXISTS WorldCupMatches_Fact;

CREATE TABLE WorldCupMatches_Fact (
    Year INT,
    Datetime DATETIME,
    Stage NVARCHAR(100),
    Stadium NVARCHAR(150),
    City NVARCHAR(50),

    HomeTeamName NVARCHAR(50),
    AwayTeamName NVARCHAR(50),

    WinConditions NVARCHAR(100),

    Attendance INT,

    HomeTeamGoals INT,
    AwayTeamGoals INT,

    GoalDifference INT,
    Winner NVARCHAR(50),

    ResultCategory NVARCHAR(50),
    HighScoringMatch NVARCHAR(10),
    KnockOutMatch NVARCHAR(10)
);

SELECT * FROM WorldCupMatches_Fact
SELECT COUNT(*) FROM WorldCupMatches_Fact;

/*Explore Data*/
SELECT TOP 10 * FROM WorldCupMatches_Fact;

/*Total Goals Scored By Home Teams*/
SELECT HomeTeamName, SUM(HomeTeamGoals) AS 'TotalGoals'
FROM WorldCupMatches_Fact
GROUP BY HomeTeamName
ORDER BY TotalGoals DESC;

SELECT AwayTeamName AS Team, SUM(AwayTeamGoals) AS 'TotalGoals'
FROM WorldCupMatches_Fact
GROUP BY AwayTeamName
ORDER BY TotalGoals DESC;

/*Compare Home vs Away Goal Strength*/
SELECT HomeTeamName AS Team, SUM(HomeTeamGoals) AS HomeGoals
FROM WorldCupMatches_Fact
GROUP BY HomeTeamName

UNION ALL

SELECT AwayTeamName AS Team, SUM(AwayTeamGoals) AS AwayGoals
FROM WorldCupMatches_Fact
GROUP BY AwayTeamName;

/*Total Goals by Team - Combined*/

SELECT TOP 5 Team, SUM(Goals) FROM (
	(SELECT HomeTeamName AS Team, SUM(HomeTeamGoals) AS Goals
	FROM WorldCupMatches_Fact
	GROUP BY HomeTeamName

	UNION ALL

	SELECT AwayTeamName AS Team, SUM(AwayTeamGoals) AS Goals
	FROM WorldCupMatches_Fact
	GROUP BY AwayTeamName)
	) AS CombinedGoal
GROUP BY Team
ORDER BY SUM(Goals) DESC

/*Goal Difference Dominance*/

SELECT Winner, AVG(GoalDifference) AS AvgGoalDifference
FROM WorldCupMatches_Fact
WHERE Winner IS NOT NULL
GROUP BY Winner
ORDER BY AvgGoalDifference DESC;

SELECT
    Winner,
    COUNT(*) AS MatchesWon,
    AVG(GoalDifference) AS AvgGoalDifference
FROM WorldCupMatches_Fact
WHERE Winner IS NOT NULL
GROUP BY Winner
HAVING COUNT(*) >= 10
ORDER BY MatchesWon DESC;

SELECT MAX(AvgAttendance) FROM (
SELECT
    Year,
    SUM(HomeTeamGoals + AwayTeamGoals) AS TotalGoals,
    AVG(Attendance) AS AvgAttendance
FROM WorldCupMatches_Fact
GROUP BY Year) X
/*High Scoring Match Analysis*/

SELECT Stage, COUNT(*) AS 'HighScoringMatches'
FROM WorldCupMatches_Fact
WHERE HighScoringMatch = 'Yes'
GROUP BY Stage
ORDER BY HighScoringMatches DESC

/*High Scoring + Knockout Games*/
SELECT Stage, COUNT(*) AS 'HighScoringMatches'
FROM WorldCupMatches_Fact
WHERE HighScoringMatch = 'Yes' AND KnockOutMatch = 'Yes'
GROUP BY Stage
ORDER BY HighScoringMatches DESC

/*Rank Teams by Total Goals*/
With TeamGoals AS 
(
	SELECT Team, SUM(Goals) AS TotalGoals 
	FROM (
        SELECT HomeTeamName AS Team,
               HomeTeamGoals AS Goals
        FROM WorldCupMatches_Fact

        UNION ALL

        SELECT AwayTeamName,
               AwayTeamGoals
        FROM WorldCupMatches_Fact
    ) T
	GROUP BY Team
)

SELECT Team,
TotalGoals,
RANK() OVER (ORDER BY TotalGoals DESC) AS GoalRank,
DENSE_RANK() OVER (ORDER BY TotalGoals DESC) AS GoalDesnseRank
FROM TeamGoals

/*Query 2 — Goals by Decade*/

SELECT 
(Year / 10) * 10 AS Decade,
SUM(HomeTeamGoals + AwayTeamGoals) AS TotalGoals
FROM WorldCupMatches_Fact
GROUP BY (Year / 10) * 10
ORDER BY Decade DESC

/*Query 3 — Most Frequently Used Stadiums*/

SELECT Stadium, COUNT(*) AS MatchHosted
FROM WorldCupMatches_Fact
GROUP BY Stadium
HAVING COUNT(*) > 5
ORDER BY MatchHosted DESC

/*Query 4 — Most Dominant Wins*/

SELECT TOP 10
Year,
Stadium,
City,
HomeTeamName,
AwayTeamName,
GoalDifference
FROM 
WorldCupMatches_Fact
ORDER BY GoalDifference DESC

SELECT COUNT(*) FROM 
WorldCupMatches_Fact
WHERE Stadium = 'Estadio Azteca'
AND HighScoringMatch = 'No'

SELECT DISTINCT HighScoringMatch
FROM WorldCupMatches_Fact;

SELECT Winner, COUNT(*) AS MatchesWon
FROM WorldCupMatches_Fact
WHERE WINNER IS NOT NULL
GROUP BY Winner
ORDER BY COUNT(*) DESC


CREATE VIEW vw_WorldCupDashboard AS
	SELECT Year,
	Stage,
	Stadium,
	Attendance,
	HomeTeamGoals,
	AwayTeamGoals,
	GoalDifference,
	Winner,
	HighScoringMatch,
	KnockOutMatch
	FROM WorldCupMatches_Fact

SELECT  TOP 5 * FROM vw_WorldCupDashboard
------------------------------------------------------

/*

For Power BI Dashboarding 

KPI1 - Total Matches - 852
KPI2 - Total Goals - Sum(HomeTeamGoals + AwayTeamGoals)
KPI3 - Total Attendance - SUM(Attendance)
KPI4 - Most Dominant Team - Brazil with 223 Goals
KPI5 - Most Used Stadium - Estadio Azteca

Chart1 - Top 10 Teams by Goals - Team vs Total Goals
Chart2 - Goals Trend Over Time - Year vs Total Goals
Chart3 - Attendance Trend - Year vs Attendance
Chart4 - High Scoring Match by Stage - Stage vs Count(HighScoringMatch)
Chart5 - Stadium Usage - Stadium vs Matches Hosted





*/


