--Different ways to replace NULL in sql serve

use SQLPRACTICE
drop table if exists tblEmployee2;

--SQL Script to create tblEmployee and tblDepartment tables

Create table tblEmployee2
(
     EmployeeId int primary key,
     Name2 nvarchar(50),
     ManagerId int
)
Go

Insert into tblEmployee2 values (1, 'mike', 3)
Insert into tblEmployee2 values (2, 'rob', 1)
Insert into tblEmployee2 values (3, 'tod', Null)
Insert into tblEmployee2 values (4, 'ben', 1)
Insert into tblEmployee2 values (5, 'Sam', 1)

--In the output, MANAGER column, for Todd's rows is NULL. I want to replace the NULL value, with 'No Manager'

--Replacing NULL value using ISNULL() function: We are passing 2 parameters to IsNULL() function. If M.Name returns NULL, then 'No Manager' string is used as the replacement value.

SELECT E.Name2 as Employee, ISNULL(M.Name2,'No Manager') as Manager
FROM tblEmployee2 E
LEFT JOIN tblEmployee2 M
ON E.ManagerID = M.EmployeeID

--Replacing NULL value using CASE Statement:
SELECT E.Name2 as Employee, CASE WHEN M.Name2 IS NULL THEN 'No Manager' 
   ELSE M.Name2 END as Manager
FROM  tblEmployee2 E
LEFT JOIN tblEmployee2 M
ON   E.ManagerID = M.EmployeeID

--Replacing NULL value using COALESCE() function: COALESCE() function, returns the first NON NULL value.
SELECT E.Name2 as Employee, COALESCE(M.Name2, 'No Manager') as Manager
FROM tblEmployee2 E
LEFT JOIN tblEmployee2 M
ON E.ManagerID = M.EmployeeID

--Coalesce() function in sql server Consider the Employees Table below. Not all employees have their First, Midde and Last Names filled. Some of the employees has First name missing, some of them have Middle Name missing and some of them last name.


drop table if exists tblEmployee3;
Create table tblEmployee3
(
     Id int primary key,
     Firstname nvarchar(50),
     Middlename nvarchar(50),
	 Lastname nvarchar(50)
)
Go
Insert into tblEmployee3 (Id, Firstname,Middlename, Lastname) 
values (1,'sam', NULL, NULL),(2,NULL, 'ram', NULL),(3,NULL, NULL, 'sara'),(4,'ben', 'parker', NULL),(5,'james', 'nick', 'nancy');

--We are passing FirstName, MiddleName and LastName columns as parameters to the COALESCE() function. The COALESCE() function returns the first non null value from the 3 columns.

SELECT Id, COALESCE(FirstName, MiddleName, LastName) AS Name1
FROM tblEmployee3

--Union and union all in sql server
--UNION and UNION ALL operators in SQL Server, are used to combine the result-set of two or more SELECT queries

drop table if exists tblIndiaCustomers;

Create table tblIndiaCustomers
(
     Id int primary key,
     Firstname nvarchar(50),
     email nvarchar(50)

)
Go
Insert into tblIndiaCustomers(Id, Firstname,email) 
values (1,'raj', 'r@gmail.com'),(2,'sam', 's@gmail.com');

drop table if exists tblUKCustomers;
Create table tblUKCustomers
(
     Id int primary key,
     Firstname nvarchar(50),
     email nvarchar(50)

)
Go
Insert into tblUKCustomers(Id, Firstname,email) 
values (1,'ben', 'b@gmail.com'),(2,'sam', 's@gmail.com');

Select Id,Firstname, email from tblIndiaCustomers
UNION ALL
Select Id, Firstname, email from tblUKCustomers

Select Id,Firstname, email from tblIndiaCustomers
UNION
Select Id, Firstname, email from tblUKCustomers

--Differences between UNION and UNION ALL 
--From the output, it is very clear that, UNION removes duplicate rows, where as UNION ALL does not. When use UNION, to remove the duplicate rows, sql server has to to do a distinct sort, which is time consuming. For this reason, UNION ALL is much faster than UNION. 

--If you want to see the cost of DISTINCT SORT, you can turn on the estimated query execution plan using CTRL + L.

-- For UNION and UNION ALL to work, the Number, Data types, and the order of the columns in the select statements should be same.

--error bcoz firstname datatype varchar and id type int 
Select Firstname, Id, email from tblIndiaCustomers
UNION ALL
Select Id, Firstname, email from tblUKCustomers

Select Firstname,email,Id from tblIndiaCustomers
UNION ALL
Select email, Firstname, Id from tblUKCustomers

--If you want to sort, the results of UNION or UNION ALL, the ORDER BY caluse should be used on the last SELECT statement as shown below.

Select Id, Firstname, email from tblIndiaCustomers
UNION ALL
Select Id, Firstname, email from tblUKCustomers
--UNION ALL
--Select Id, Firstname, email from tblUSCustomers

Order by Firstname

--The following query, raises a syntax error
SELECT Id, FirstName, email FROM tblIndiaCustomers
ORDER BY FirstName
UNION ALL
SELECT Id, FirstName, email FROM tblUKCustomers
--UNION ALL
--SELECT Id,FirstName, email FROM tblUSCustomers
Difference between JOIN and UNION
JOINS and UNIONS are different things. However, this question is being asked very frequently now. UNION combines the result-set of two or more select queries into a single result-set which includes all the rows from all the queries in the union, where as JOINS, retrieve data from two or more tables based on logical relationships between the tables. In short, UNION combines rows from 2 or more tables, where JOINS combine columns from 2 or more table.