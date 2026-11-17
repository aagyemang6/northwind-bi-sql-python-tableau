USE [Northwind]
GO

IF OBJECT_ID('dbo.EmployeeRankedByYearMonthNetSales', 'P') IS NOT NULL
    DROP PROCEDURE dbo.EmployeeRankedByYearMonthNetSales
GO

CREATE PROCEDURE dbo.EmployeeRankedByYearMonthNetSales
    @YM int,
    @MinNetSales decimal(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    /*
    Calculates total net sales per employee for a specific Year-Month.
    Net Sales = UnitPrice * Quantity * (1 - Discount)
    
    Parameters:
    @YM: Integer in YYYYMM format (e.g. 199707)
    @MinNetSales: Minimum total net sales threshold
    */

    SELECT 
        @YM AS [YearMonth],
        e.EmployeeID,
        e.FirstName AS [Employee First Name],
        e.LastName AS [Employee Last Name],
        CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS decimal(10,2)) AS [Total NetSales],
        COUNT(DISTINCT o.OrderID) AS [Total count of orders linked to],
        RANK() OVER (ORDER BY SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC) AS [Rank]
    FROM 
        dbo.Employees e
        INNER JOIN dbo.Orders o ON e.EmployeeID = o.EmployeeID
        INNER JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
    WHERE 
        -- Extract YYYYMM from OrderDate
        -- 112 style is YYYYMMDD
        CAST(CONVERT(VARCHAR(6), o.OrderDate, 112) AS INT) = @YM
    GROUP BY 
        e.EmployeeID, 
        e.FirstName, 
        e.LastName
    HAVING 
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) >= @MinNetSales
    ORDER BY 
        [Rank] ASC,
        e.LastName ASC;

END
GO
