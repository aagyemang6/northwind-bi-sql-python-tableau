USE [Northwind]
GO

IF OBJECT_ID('dbo.Dayparts', 'V') IS NOT NULL
    DROP VIEW dbo.Dayparts
GO

/*
View: Dayparts
Source Table: TimeSlotLookup (assumed columns: Daypart, BeginHour, EndHour)
Returns: 
    [Daypart]: Name of the daypart
    [Hours]: Formatted string "Start - End" (e.g. 5AM - 11AM)
    [Sort]: Sorting order (Morning=1, Afternoon=2, Night=3, Grave=4)
*/

CREATE VIEW dbo.Dayparts
AS
SELECT 
    Daypart,
    -- Format BeginHour
    (CASE 
        WHEN BeginHour = 0 THEN '12AM'
        WHEN BeginHour < 12 THEN CAST(BeginHour AS VARCHAR(2)) + 'AM'
        WHEN BeginHour = 12 THEN '12PM'
        ELSE CAST(BeginHour - 12 AS VARCHAR(2)) + 'PM'
     END) + ' - ' +
    -- Format EndHour
    (CASE 
        WHEN EndHour = 0 THEN '12AM'
        WHEN EndHour < 12 THEN CAST(EndHour AS VARCHAR(2)) + 'AM'
        WHEN EndHour = 12 THEN '12PM'
        ELSE CAST(EndHour - 12 AS VARCHAR(2)) + 'PM'
     END) AS [Hours],
    
    -- Sort Column
    CASE Daypart
        WHEN 'Morning' THEN 1
        WHEN 'Afternoon' THEN 2
        WHEN 'Night' THEN 3
        WHEN 'Grave' THEN 4
        ELSE 5 -- Fallback
    END AS [Sort]
FROM 
    dbo.TimeSlotLookup
GO
