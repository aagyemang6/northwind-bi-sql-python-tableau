# Northwind BI: SQL, Python and Tableau

Three short business intelligence exercises I completed for a BI developer take-home assessment in February 2026. Together they cover the everyday work of a BI developer: writing parameterized SQL, reshaping messy API data with Python, and building a sales dashboard in Tableau.

The SQL and Tableau work runs on **Northwind**, Microsoft's public sample database of a small trading company's orders, customers, employees and products.

## 1. SQL: ranking employees by monthly net sales

**The task:** write a stored procedure that, for a given year and month and a minimum sales threshold, returns each qualifying employee's total net sales and order count, ranked from highest to lowest.

**My approach** ([sql/EmployeeRankedByYearMonthNetSales.sql](sql/EmployeeRankedByYearMonthNetSales.sql)):

- Net sales per order line is `UnitPrice * Quantity * (1 - Discount)`, summed per employee.
- The `@YM` parameter (for example `199707`) is matched against each order date converted to `YYYYMM`.
- `HAVING` applies the minimum-sales threshold after aggregation, since it filters totals, not individual orders.
- `RANK()` assigns the rank, so employees with equal sales share a rank. Ties are then ordered by last name.
- `COUNT(DISTINCT OrderID)` counts orders, not order lines.

**Tests:** [sql/test_employee_ranked_sp.sql](sql/test_employee_ranked_sp.sql) runs three cases, and [sql/test_output.txt](sql/test_output.txt) has the results. For March 1998 with a $7,500 minimum, five employees qualify, led by Nancy Davolio with $24,827.45 across 11 orders.

## 2. SQL: a reporting view of dayparts (optional bonus task)

**The task:** create a view over a time-slot lookup table that shows each part of the day (Morning, Afternoon, Night, Grave) with its hours formatted as text, for example `5AM - 11AM`, in a fixed sort order.

**My approach** ([sql/Dayparts.sql](sql/Dayparts.sql)): `CASE` expressions convert 24-hour values into 12-hour labels, handling midnight and noon explicitly, and a second `CASE` sets the sort order. Because it is a view, it always reflects the current lookup table.

**Known limitation:** the view assumes the lookup table holds one row per daypart. If the table kept a history of changed hours, the view would need to pick the latest row for each daypart, for example with `ROW_NUMBER()` over an effective date.

## 3. Python: flattening nested JSON into a CSV

**The task:** turn a nested JSON extract of customers and their locations into a flat table with one row per location: `CustomerId, IsPrimaryLocation, Phone, Email, Address`, where `Address` joins two address lines. Customers can have any number of locations.

**My approach** ([python/python_json_transform.py](python/python_json_transform.py)): walk the nested structure customer by customer, emit one row per location, and write a standard comma-separated file with Python's `csv` module, which quotes any field containing a comma. It uses only the standard library.

**Run it:**

```bash
cd python
python python_json_transform.py
```

The input here, [python_json_transform_data.json](python/python_json_transform_data.json), is a small made-up sample with the same structure as the original extract. The result is [python_json_transform_output.csv](python/python_json_transform_output.csv).

## 4. Tableau: top sales dashboard

**The task:** build a sales dashboard from Northwind using an extracted data source.

**My approach:**

- [sql/TableauDataSource.sql](sql/TableauDataSource.sql) creates one flat reporting view joining orders, order lines, customers, employees, products, categories and suppliers, with net sales calculated per line. Inner join between orders and order lines (every sale needs both), left joins for the descriptive tables so a missing lookup never drops a sale.
- [tableau/northwind_sales_dashboard.twb](tableau/northwind_sales_dashboard.twb) is the "Top Sales Dashboard": top 10 sales by country, by product category and by customer company, plus a detail table, with filters for year and customer country.

To open the workbook you need Tableau Desktop and a SQL Server instance with Northwind and the view above installed.

## Run the SQL yourself

1. Install SQL Server (the free Developer or Express edition works).
2. Install Northwind from Microsoft's samples: [microsoft/sql-server-samples](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs).
3. Run `EmployeeRankedByYearMonthNetSales.sql`, then `test_employee_ranked_sp.sql`.
4. Run `TableauDataSource.sql` before opening the workbook.

## Notes

- This repository contains only my own work. The assessment's instructions and supporting files belong to the company that set it and are not included.
- After submission I tidied the Python script's comments for readability. The logic is unchanged.

## Tools

SQL Server (T-SQL), Python 3, Tableau Desktop.
