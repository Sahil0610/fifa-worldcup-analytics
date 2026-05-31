CREATE VIEW vw_WorldCupDashboard
AS
SELECT
    Year,
    Stage,
    Stadium,
    Attendance,
    HomeTeamGoals,
    AwayTeamGoals,
    GoalDifference,
    Winner,
    HighScoringMatch,
    KnockOutMatch
FROM WorldCupMatches_Fact;