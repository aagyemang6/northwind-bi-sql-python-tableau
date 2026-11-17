USE [Northwind]
GO

-- Test Case 1
-- YM: 199707, Minimum Net Sales: 7000
PRINT '--------------------------------------------------'
PRINT 'Test Case 1: YM=199707, MinNetSales=7000'
EXEC dbo.EmployeeRankedByYearMonthNetSales 
    @YM = 199707, 
    @MinNetSales = 7000;
GO

-- Test Case 2
-- YM: 199612, Minimum Net Sales: 6440
PRINT '--------------------------------------------------'
PRINT 'Test Case 2: YM=199612, MinNetSales=6440'
EXEC dbo.EmployeeRankedByYearMonthNetSales 
    @YM = 199612, 
    @MinNetSales = 6440;
GO

-- Test Case 3
-- YM: 199803, Minimum Net Sales: 7500
PRINT '--------------------------------------------------'
PRINT 'Test Case 3: YM=199803, MinNetSales=7500'
EXEC dbo.EmployeeRankedByYearMonthNetSales 
    @YM = 199803, 
    @MinNetSales = 7500;
GO
