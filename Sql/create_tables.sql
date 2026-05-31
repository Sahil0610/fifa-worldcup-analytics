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