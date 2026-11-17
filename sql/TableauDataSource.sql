USE [Northwind]
GO

IF OBJECT_ID('dbo.TableauReportingView', 'V') IS NOT NULL
    DROP VIEW dbo.TableauReportingView
GO

/*
View: TableauReportingView
Purpose: Provides a denormalized/flattened dataset for Tableau reporting.
Content: Joins Orders, Order Details, Customers, Employees, Products, Categories, and Suppliers.
*/

CREATE VIEW dbo.TableauReportingView
AS
SELECT 
    -- Order Information
    o.OrderID,
    o.OrderDate,
    o.RequiredDate,
    o.ShippedDate,
    o.Freight,
    o.ShipCity,
    o.ShipCountry,
    o.ShipRegion,
    
    -- Customer Information
    c.CustomerID,
    c.CompanyName AS [Customer Name],
    c.City AS [Customer City],
    c.Country AS [Customer Country],
    
    -- Employee Information
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS [Employee Name],
    e.Title AS [Employee Title],
    
    -- Product Information
    p.ProductID,
    p.ProductName,
    cat.CategoryName,
    sup.CompanyName AS [Supplier Name],
    
    -- Sales Metrics
    od.UnitPrice,
    od.Quantity,
    od.Discount,
    -- Calculate Line Item Total (Net Sales)
    CAST(od.UnitPrice * od.Quantity * (1 - od.Discount) AS decimal(10,2)) AS [Net Sales]

FROM 
    dbo.Orders o
    INNER JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
    LEFT JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
    LEFT JOIN dbo.Employees e ON o.EmployeeID = e.EmployeeID
    LEFT JOIN dbo.Products p ON od.ProductID = p.ProductID
    LEFT JOIN dbo.Categories cat ON p.CategoryID = cat.CategoryID
    LEFT JOIN dbo.Suppliers sup ON p.SupplierID = sup.SupplierID
GO
