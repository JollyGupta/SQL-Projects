-- Advanced Joins in SQL

1. Advanced or intelligent joins in SQL Server
2. Retrieve only the non matching rows from the left table
3. Retrieve only the non matching rows from the right table
4. Retrieve only the non matching rows from both the left and right table
=============================================================

use SQLPRACTICE
drop table if exists tblDepartment;

--SQL Script to create tblEmployee and tblDepartment tables

Create table tblDepartment
(
     ID int primary key,
     DepartmentName nvarchar(50),
     Location1 nvarchar(50),
     DepartmentHead nvarchar(50)
)
Go

Insert into tblDepartment values (1, 'IT', 'London', 'Rick')
Insert into tblDepartment values (2, 'Payroll', 'Delhi', 'Ron')
Insert into tblDepartment values (3, 'HR', 'New York', 'Christie')
Insert into tblDepartment values (4, 'Other Department', 'Sydney', 'Cindrella')
Go

drop table if exists tblEmployee;
Create table tblEmployee
(
     ID int primary key,
     Name1 nvarchar(50),
     Gender nvarchar(50),
     Salary int,
     DepartmentId int foreign key references tblDepartment(ID)
)
Go

Insert into tblEmployee values (1, 'Tom', 'Male', 4000, 1)
Insert into tblEmployee values (2, 'Pam', 'Female', 3000, 3)
Insert into tblEmployee values (3, 'John', 'Male', 3500, 1)
Insert into tblEmployee values (4, 'Sam', 'Male', 4500, 2)
Insert into tblEmployee values (5, 'Todd', 'Male', 2800, 2)
Insert into tblEmployee values (6, 'Ben', 'Male', 7000, 1)
Insert into tblEmployee values (7, 'Sara', 'Female', 4800, 3)
Insert into tblEmployee values (8, 'Valarie', 'Female', 5500, 1)
Insert into tblEmployee values (9, 'James', 'Male', 6500, NULL)
Insert into tblEmployee values (10, 'Russell', 'Male', 8800, NULL)
Go


--How to retrieve only the non matching rows from the left table. The output should be as shown below:

SELECT  Name1, Gender, Salary, DepartmentName
FROM    tblEmployee E
LEFT JOIN  tblDepartment D
ON   E.DepartmentId = D.Id
WHERE  D.Id IS NULL

--How to retrieve only the non matching rows from the right table

SELECT   Name1, Gender, Salary, DepartmentName
FROM     tblEmployee E
RIGHT JOIN    tblDepartment D
ON   E.DepartmentId = D.Id
WHERE   E.DepartmentId IS NULL

--How to retrieve only the non matching rows from both the left and right table. Matching rows should be eliminated.

SELECT         Name1, Gender, Salary, DepartmentName
FROM              tblEmployee E
FULL JOIN      tblDepartment D
ON             E.DepartmentId = D.Id
WHERE          E.DepartmentId IS NULL
OR             D.Id IS NULL

--Self Joins
A MANAGER is also an EMPLOYEE. Both the, EMPLOYEE and MANAGER rows, are present in the same table. Here we are joining tblEmployee with itself using different alias names, E for Employee and M for Manager. We are using LEFT JOIN, to get the rows with ManagerId NULL. You can see in the output TODD's record is also retrieved, but the MANAGER is NULL. If you replace LEFT JOIN with INNER JOIN, you will not get TODD's record.
-------------------------------------------------
drop table if exists tblEmployee1;
Create table tblEmployee1
(
     EmployeeId int primary key,
     Name2 nvarchar(50),
     ManagerId int
)
Go

Insert into tblEmployee1 values (1, 'mike', 3)
Insert into tblEmployee1 values (2, 'rob', 1)
Insert into tblEmployee1 values (3, 'tod', Null)
Insert into tblEmployee1 values (4, 'ben', 1)
Insert into tblEmployee1 values (5, 'Sam', 1)

Select E.Name2 as Employee, M.Name2 as Manager
from tblEmployee1 E
Left Join tblEmployee1 M
On E.ManagerId = M.EmployeeId

Select E.Name2 as Employee, M.Name2 as Manager
from tblEmployee1 E
inner Join tblEmployee1 M
On E.ManagerId = M.EmployeeId

Select E.Name2 as Employee, M.Name2 as Manager
from tblEmployee1 E
cross Join tblEmployee1 M
