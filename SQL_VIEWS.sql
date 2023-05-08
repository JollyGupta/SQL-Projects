--What is a View?
--A view is nothing more than a saved SQL query. A view can also be considered as a virtual table.

Drop Table if exists tblEmployee17;
CREATE TABLE tblEmployee17
(
  Id int Primary Key,
  [Name] nvarchar(30),
  Salary int,
  Gender nvarchar(10),
  DepartmentId int
)

Drop Table if exists tblDepartment17;
CREATE TABLE tblDepartment17
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)

Insert into tblDepartment17 values (1,'IT')
Insert into tblDepartment17 values (2,'Payroll')
Insert into tblDepartment17 values (3,'HR')
Insert into tblDepartment17 values (4,'Admin')


Insert into tblEmployee17 values (1,'John', 5000, 'Male', 3)
Insert into tblEmployee17 values (2,'Mike', 3400, 'Male', 2)
Insert into tblEmployee17 values (3,'Pam', 6000, 'Female', 1)
Insert into tblEmployee17 values (4,'Todd', 4800, 'Male', 4)
Insert into tblEmployee17 values (5,'Sara', 3200, 'Female', 1)
Insert into tblEmployee17 values (6,'Ben', 4800, 'Male', 3)


--To get the expected output, we need to join tblEmployees table with tblDepartments table. 

Select Id, [Name], Salary, Gender, DeptName
from tblEmployee17
join tblDepartment17
on tblEmployee17.DepartmentId = tblDepartment17.DeptId

--Now let's create a view, using the JOINS query, we have just written.

Create View vWEmployeesByDepartment
as
Select Id, [Name], Salary, Gender, DeptName
from tblEmployee17
join tblDepartment17
on tblEmployee17.DepartmentId = tblDepartment17.DeptId

--To select data from the view, SELECT statement can be used the way, we use it with a table.
SELECT * from vWEmployeesByDepartment

--When this query is executed, the database engine actually retrieves the data from the underlying base tables, tblEmployees and tblDepartments. The View itself, doesnot store any data by default. However, we can change this default behaviour, which we will talk about in a later session. So, this is the reason, a view is considered, as just, a stored query or a virtual table.

/*Advantages of using views:
1. Views can be used to reduce the complexity of the database schema, for non IT users. The sample view, vWEmployeesByDepartment, hides the complexity of joins. Non-IT users, finds it easy to query the view, rather than writing complex joins.

2. Views can be used as a mechanism to implement row and column level security.
Row Level Security:
For example, I want an end user, to have access only to IT Department employees. If I grant him access to the underlying tblEmployees and tblDepartments tables, he will be able to see, every department employees. To achieve this, I can create a view, which returns only IT Department employees, and grant the user access to the view and not to the underlying table.*/

--View that returns only IT department employees:

Create View vWITDepartment_Employees
as
Select Id, [Name], Salary, Gender, DeptName
from tblEmployee17
join tblDepartment17
on tblEmployee17.DepartmentId = tblDepartment17.DeptId
where tblDepartment17.DeptName = 'IT'

--Column Level Security:
--Salary is confidential information and I want to prevent access to that column. To achieve this, we can create a view, which excludes the Salary column, and then grant the end user access to this views, rather than the base tables.

--View that returns all columns except Salary column:
DROP VIEW vWEmployeesNonConfidentialData
Create View vWEmployeesNonConfidentialData
as
Select Id, [Name], Gender, DeptName
from tblEmployee17
join tblDepartment17
on tblEmployee17.DepartmentId = tblDepartment17.DeptId
SELECT * from  vWEmployeesNonConfidentialData

-- Views can be used to present only aggregated data and hide detailed data.
--View that returns summarized data, Total number of employees by Department.
--DROP VIEW vWEmployeesCountByDepartment
Create View vWEmployeesCountByDepartment
as
Select DeptName, COUNT(Id) as TotalEmployees17
from tblEmployee17
join tblDepartment17
on tblEmployee17.DepartmentId = tblDepartment17.DeptId
Group By DeptName
SELECT * from vWEmployeesCountByDepartment

--To look at view definition - 
sp_helptext vWEmployeesByDepartment

--To modify a view - 

ALTER VIEW vWEmployeesCountByDepartment
as
Select DeptName, COUNT([Name]) as TotalEmployees17
from tblEmployee17
join tblDepartment17
on tblEmployee17.DepartmentId = tblDepartment17.DeptId
Group By DeptName
SELECT * from vWEmployeesCountByDepartment

--To Drop a view - 
DROP VIEW name vWEmployeesNonConfidentialData
select  * from sys.views

---------------------Updateable Views 
Drop Table if exists tblEmployee18;
CREATE TABLE tblEmployee18
(
  Id int Primary Key,
  [Name] nvarchar(30),
  Salary int,
  Gender nvarchar(10),
  DepartmentId int
)



Insert into tblEmployee18 values (1,'John', 5000, 'Male', 3)
Insert into tblEmployee18 values (2,'Mike', 3400, 'Male', 2)
Insert into tblEmployee18 values (3,'Pam', 6000, 'Female', 1)
Insert into tblEmployee18 values (4,'Todd', 4800, 'Male', 4)
Insert into tblEmployee18 values (5,'Sara', 3200, 'Female', 1)
Insert into tblEmployee18 values (6,'Ben', 4800, 'Male', 3)

--Let's create a view, which returns all the columns from the tblEmployees table, except Salary column.

Create view vWEmployeesDataExceptSalary
as
Select Id, [Name], Gender, DepartmentId
from tblEmployee18

--Select data from the view: A view does not store any data. So, when this query is executed, the database engine actually retrieves data, from the underlying tblEmployee base table.
Select * from vWEmployeesDataExceptSalary

--Is it possible to Insert, Update and delete rows, from the underlying tblEmployees table, using view vWEmployeesDataExceptSalary? Yes, SQL server views are updateable.

--The following query updates, Name column from Mike to Mikey. Though, we are updating the view, SQL server, correctly updates the base table tblEmployee. To verify, execute, SELECT statement, on tblEmployee table.

Update vWEmployeesDataExceptSalary 
Set [Name] = 'Mikey' Where Id = 2
Select * from vWEmployeesDataExceptSalary

--Along the same lines, it is also possible to insert and delete rows from the base table using views

Delete from vWEmployeesDataExceptSalary where Id = 2
Select * from vWEmployeesDataExceptSalary

Insert into vWEmployeesDataExceptSalary values (2, 'Mikey', 'Male', 2)
Select * from vWEmployeesDataExceptSalary

--Now, let us see, what happens if our view is based on multiple base tables. For this purpose, let's create tblDepartment table and populate with some sample data.

Drop Table if exists tblDepartment18;
CREATE TABLE tblDepartment18
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)

Insert into tblDepartment18 values (1,'IT')
Insert into tblDepartment18 values (2,'Payroll')
Insert into tblDepartment18 values (3,'HR')
Insert into tblDepartment18 values (4,'Admin')

--Create a view which joins tblEmployee and tblDepartment tables
--View that joins tblEmployee and tblDepartment

Create view vwEmployeeDetailsByDepartment
as
Select Id, [Name], Salary, Gender, DeptName
from tblEmployee18
join tblDepartment18
on tblEmployee18.DepartmentId = tblDepartment18.DeptId

Select * from vwEmployeeDetailsByDepartment

--Now, let's update, John's department, from HR to IT. At the moment, there are 2 employees (Ben, and John) in the HR department.

Update vwEmployeeDetailsByDepartment 
set DeptName='IT' where Name = 'John'
Select * from vwEmployeeDetailsByDepartment

Select * from tblEmployee18
Select * from tblDepartment18

-- HR is converted in IT 

--Notice, that Ben's department is also changed to IT. To understand the reasons for incorrect UPDATE, select Data from tblDepartment and tblEmployee base tables.

--The UPDATE statement, updated DeptName from HR to IT in tblDepartment table, instead of upadting DepartmentId column in tblEmployee table. So, the conclusion - If a view is based on multiple tables, and if you update the view, it may not update the underlying base tables correctly. To correctly update a view, that is based on multiple table, INSTEAD OF triggers are used.

-------------Indexed views 

--What is an Indexed View or What happens when you create an Index on a view?
--A standard or Non-indexed view, is just a stored SQL query. When, we try to retrieve data from the view, the data is actually retrieved from the underlying base tables. So, a view is just a virtual table it does not store any data, by default.

--However, when you create an index, on a view, the view gets materialized. This means, the view is now, capable of storing data. In SQL server, we call them Indexed views and in Oracle, Materialized views.

--Let's now, look at an example of creating an Indexed view.

--Script to create table tblProduct
Create Table tblProduct
(
 ProductId int primary key,
 Name nvarchar(20),
 UnitPrice int
)

--Script to pouplate tblProduct, with sample data
Insert into tblProduct Values(1, 'Books', 20)
Insert into tblProduct Values(2, 'Pens', 14)
Insert into tblProduct Values(3, 'Pencils', 11)
Insert into tblProduct Values(4, 'Clips', 10)

--Script to create table tblProductSales
Create Table tblProductSales
(
 ProductId int,
 QuantitySold int
)

--Script to pouplate tblProductSales, with sample data
Insert into tblProductSales values(1, 10)
Insert into tblProductSales values(3, 23)
Insert into tblProductSales values(4, 21)
Insert into tblProductSales values(2, 12)
Insert into tblProductSales values(1, 13)
Insert into tblProductSales values(3, 12)
Insert into tblProductSales values(4, 13)
Insert into tblProductSales values(1, 11)
Insert into tblProductSales values(2, 12)
Insert into tblProductSales values(1, 14)

select * from tblProduct;
select * from tblProductSales;

--Create a view which returns Total Sales and Total Transactions by Product.
--Script to create view vWTotalSalesByProduct

Create view vWTotalSalesByProduct
with SchemaBinding
as
Select Name, 
SUM(ISNULL((QuantitySold * UnitPrice), 0)) as TotalSales, 
COUNT_BIG(*) as TotalTransactions -- 
from dbo.tblProductSales
join dbo.tblProduct
on dbo.tblProduct.ProductId = dbo.tblProductSales.ProductId
group by [Name]

select * from vWTotalSalesByProduct;
select * from tblProduct;
select * from tblProductSales;
/*If you want to create an Index, on a view, the following rules should be followed by the view. For the complete list of all rules, please check MSDN.

1. The view should be created with SchemaBinding option dbo.

2. If an Aggregate function in the SELECT LIST, references an expression, and if there is a possibility for that expression to become NULL, then, a replacement value should be specified. In this example, we are using, ISNULL() function, to replace NULL values with ZERO.

3. If GROUP BY is specified, the view select list must contain a COUNT_BIG(*) expression

4. The base tables in the view, should be referenced with 2 part name. In this example, tblProduct and tblProductSales are referenced using dbo.tblProduct and dbo.tblProductSales respectively.

Now, let's create an Index on the view:
The first index that you create on a view, must be a unique clustered index. After the unique clustered index has been created, you can create additional nonclustered indexes. */

Create Unique Clustered Index UIX_vWTotalSalesByProduct_Name
on vWTotalSalesByProduct([Name])

select * from vWTotalSalesByProduct [Name]

--Since, we now have an index on the view, the view gets materialized. The data is stored in the view. So when we execute Select * from vWTotalSalesByProduct, the data is retrurned from the view itself, rather than retrieving data from the underlying base tables.

Indexed views, can significantly improve the performance of queries that involves JOINS and Aggeregations. The cost of maintaining an indexed view is much higher than the cost of maintaining a table index.

Indexed views are ideal for scenarios, where the underlying data is not frequently changed. Indexed views are more often used in OLAP systems, because the data is mainly used for reporting and analysis purposes. Indexed views, may not be suitable for OLTP systems, as the data is frequently addedd and changed.

--Limitations of views 
1. You cannot pass parameters to a view. Table Valued functions are an excellent replacement for parameterized views.

CREATE TABLE tblEmployee19
(
  Id int Primary Key,
  Name nvarchar(30),
  Salary int,
  Gender nvarchar(10),
  DepartmentId int
)

Insert into tblEmployee19 values (1,'John', 5000, 'Male', 3)
Insert into tblEmployee19 values (2,'Mike', 3400, 'Male', 2)
Insert into tblEmployee19 values (3,'Pam', 6000, 'Female', 1)
Insert into tblEmployee19 values (4,'Todd', 4800, 'Male', 4)
Insert into tblEmployee19 values (5,'Sara', 3200, 'Female', 1)
Insert into tblEmployee19 values (6,'Ben', 4800, 'Male', 3)

-- Error : Cannot pass Parameters to Views
Create View vWEmployeeDetails
@Gender nvarchar(20)
as
Select Id, [Name], Gender, DepartmentId
from  tblEmployee19
where Gender = @Gender

--Table Valued functions can be used as a replacement for parameterized views.

Create function fnEmployeeDetails(@Gender nvarchar(20))
Returns Table
as
Return 
(Select Id, [Name], Gender, DepartmentId
from tblEmployee19 where Gender = @Gender)

--Calling the function
Select * from dbo.fnEmployeeDetails('Male')

2. Rules and Defaults cannot be associated with views.

3. The ORDER BY clause is invalid in views unless TOP or FOR XML is also specified.

Create View vWEmployeeDetailsSorted
as
Select Id, Name, Gender, DepartmentId
from tblEmployee
order by Id

--If you use ORDER BY, you will get an error stating - 'The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions, unless TOP or FOR XML is also specified.'

4. Views cannot be based on temporary tables.

Create Table ##TestTempTable(Id int, Name nvarchar(20), Gender nvarchar(10))

Insert into ##TestTempTable values(101, 'Martin', 'Male')
Insert into ##TestTempTable values(102, 'Joe', 'Female')
Insert into ##TestTempTable values(103, 'Pam', 'Female')
Insert into ##TestTempTable values(104, 'James', 'Male')

-- Error: Cannot create a view on Temp Tables
Create View vwOnTempTable
as
Select Id, [Name], Gender
from ##TestTempTable