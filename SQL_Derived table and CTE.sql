--Derived tables and common table expressions

drop table if exists tblEmployee23
CREATE TABLE tblEmployee23
(
  Id int Primary Key,
  Name nvarchar(30),
  Gender nvarchar(10),
  DepartmentId int
)

drop table if exists tblDepartment23
CREATE TABLE tblDepartment23
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)


Insert into tblDepartment23 values (1,'IT')
Insert into tblDepartment23 values (2,'Payroll')
Insert into tblDepartment23 values (3,'HR')
Insert into tblDepartment23 values (4,'Admin')

Insert into tblEmployee23 values (1,'John', 'Male', 3)
Insert into tblEmployee23 values (2,'Mike', 'Male', 2)
Insert into tblEmployee23 values (3,'Pam', 'Female', 1)
Insert into tblEmployee23 values (4,'Todd', 'Male', 4)
Insert into tblEmployee23 values (5,'Sara', 'Female', 1)
Insert into tblEmployee23 values (6,'Ben', 'Male', 3)

--The query should return, the Department Name and Total Number of employees, with in the department. The departments with greatar than or equal to 2 employee should only be returned.


Create view vWEmployeeCount
as
Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
from tblEmployee23
join tblDepartment23
on tblEmployee23.DepartmentId = tblDepartment23.DeptId
group by DeptName, DepartmentId

Select DeptName, TotalEmployees 
from vWEmployeeCount
where  TotalEmployees >= 2

Note: Views get saved in the database, and can be available to other queries and stored procedures. However, if this view is only used at this one place, it can be easily eliminated using other options, like CTE, Derived Tables, Temp Tables, Table Variable etc.

--let's see, how to achieve the same using, temporary tables. We are using local temporary tables here.

Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
into #TempEmployeeCount
from tblEmployee23
join tblDepartment23
on tblEmployee23.DepartmentId = tblDepartment23.DeptId
group by DeptName, DepartmentId

Select DeptName, TotalEmployees
From #TempEmployeeCount
where TotalEmployees >= 2

Drop Table #TempEmployeeCount

Note: Temporary tables are stored in TempDB. Local temporary tables are visible only in the current session, and can be shared between nested stored procedure calls. Global temporary tables are visible to other sessions and are destroyed, when the last connection referencing the table is closed.


--Using Table Variable:
Declare @tblEmployeeCount table
(DeptName nvarchar(20),DepartmentId int, TotalEmployees int)

Insert @tblEmployeeCount
Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
from tblEmployee23
join tblDepartment23
on tblEmployee23.DepartmentId = tblDepartment23.DeptId
group by DeptName, DepartmentId

Select DeptName, TotalEmployees
From @tblEmployeeCount
where  TotalEmployees >= 2

Note: Just like TempTables, a table variable is also created in TempDB. The scope of a table variable is the batch, stored procedure, or statement block in which it is declared. They can be passed as parameters between procedures.

--Using Derived Tables
Select DeptName, TotalEmployees
from 
 (
  Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
  from tblEmployee23
  join tblDepartment23
  on tblEmployee23.DepartmentId = tblDepartment23.DeptId
  group by DeptName, DepartmentId
 ) 
as EmployeeCount
where TotalEmployees >= 2

--Note: Derived tables are available only in the context of the current query.

--Using CTE
With EmployeeCount(DeptName, DepartmentId, TotalEmployees)
as
(
 Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
 from tblEmployee23
 join tblDepartment23
 on tblEmployee23.DepartmentId = tblDepartment23.DeptId
 group by DeptName, DepartmentId
)

Select DeptName, TotalEmployees
from EmployeeCount
where TotalEmployees >= 2

--Note: A CTE can be thought of as a temporary result set that is defined within the execution scope of a single SELECT, INSERT, UPDATE, DELETE, or CREATE VIEW statement. A CTE is similar to a derived table in that it is not stored as an object and lasts only for the duration of the query.

--Common table expression (CTE) is introduced in SQL server 2005. A CTE is a temporary result set, that can be referenced within a SELECT, INSERT, UPDATE, or DELETE statement, that immediately follows the CTE.

drop table if exists tblEmployee23;
CREATE TABLE tblEmployee23
(
  Id int Primary Key,
  Name nvarchar(30),
  Gender nvarchar(10),
  DepartmentId int
)

drop table if exists tblDepartment23;
CREATE TABLE tblDepartment23
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)


Insert into tblDepartment23 values (1,'IT')
Insert into tblDepartment23 values (2,'Payroll')
Insert into tblDepartment23 values (3,'HR')
Insert into tblDepartment23 values (4,'Admin')


Insert into tblEmployee23 values (1,'John', 'Male', 3)
Insert into tblEmployee23 values (2,'Mike', 'Male', 2)
Insert into tblEmployee23 values (3,'Pam', 'Female', 1)
Insert into tblEmployee23 values (4,'Todd', 'Male', 4)
Insert into tblEmployee23 values (5,'Sara', 'Female', 1)
Insert into tblEmployee23 values (6,'Ben', 'Male', 3)

--Write a query using CTE, to display the total number of Employees by Department Name. The output should be as shown below.

--Before we write the query, let's look at the syntax for creating a CTE.

/*WITH cte_name (Column1, Column2, ..)
AS
( CTE_query )*/


With EmployeeCount(DepartmentId, TotalEmployees)
as
(
 Select DepartmentId, COUNT(*) as TotalEmployees
 from tblEmployee23
 group by DepartmentId
)

Select DeptName, TotalEmployees
from tblDepartment23
join EmployeeCount
on tblDepartment23.DeptId = EmployeeCount.DepartmentId
order by TotalEmployees

--We define a CTE, using WITH keyword, followed by the name of the CTE. In our example, EmployeeCount is the name of the CTE. Within parentheses, we specify the columns that make up the CTE. DepartmentId and TotalEmployees are the columns of EmployeeCount CTE. These 2 columns map to the columns returned by the SELECT CTE query. The CTE column names and CTE query column names can be different. Infact, CTE column names are optional. However, if you do specify, the number of CTE columns and the CTE SELECT query columns should be same. Otherwise you will get an error stating - 'EmployeeCount has fewer columns than were specified in the column list'. The column list, is followed by the as keyword, following which we have the CTE query within a pair of parentheses.

--EmployeeCount CTE is being joined with tblDepartment table, in the SELECT query, that immediately follows the CTE. Remember, a CTE can only be referenced by a SELECT, INSERT, UPDATE, or DELETE statement, that immediately follows the CTE. If you try to do something else in between, we get an error stating - 'Common table expression defined but not used'. The following SQL, raise an error.

With EmployeeCount(DepartmentId, TotalEmployees)
as
(
 Select DepartmentId, COUNT(*) as TotalEmployees
 from tblEmployee23
 group by DepartmentId
)

Select 'Hello'--can't introduced on between

Select DeptName, TotalEmployees
from tblDepartment23
join EmployeeCount
on tblDepartment23.DeptId = EmployeeCount.DepartmentId
order by TotalEmployees

--It is also, possible to create multiple CTE's using a single WITH clause.

With EmployeesCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
(
 Select DeptName, COUNT(Id) as TotalEmployees
 from tblEmployee23
 join tblDepartment23
 on tblEmployee23.DepartmentId = tblDepartment23.DeptId
 where DeptName IN ('Payroll','IT')
 group by DeptName
),


EmployeesCountBy_HR_Admin_Dept(DepartmentName, Total)
as
(
 Select DeptName, COUNT(Id) as TotalEmployees
 from tblEmployee23
 join tblDepartment23 
 on tblEmployee23.DepartmentId = tblDepartment23.DeptId
 where DeptName IN ('HR','ADMIN')
 group by DeptName 
)
Select * from EmployeesCountBy_HR_Admin_Dept 
UNION
Select * from EmployeesCountBy_Payroll_IT_Dept

=====================================================================
--Is it possible to UPDATE a CTE?
--Yes & No, depending on the number of base tables, the CTE is created upon, and the number of base tables affected by the UPDATE statement. 

drop table if exists tblEmployee;
CREATE TABLE tblEmployee
(
  Id int Primary Key,
  Name nvarchar(30),
  Gender nvarchar(10),
  DepartmentId int
)

drop table if exists tblDepartment;
CREATE TABLE tblDepartment
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)


Insert into tblDepartment values (1,'IT')
Insert into tblDepartment values (2,'Payroll')
Insert into tblDepartment values (3,'HR')
Insert into tblDepartment values (4,'Admin')

Insert into tblEmployee values (1,'John', 'Male', 3)
Insert into tblEmployee values (2,'Mike', 'Male', 2)
Insert into tblEmployee values (3,'Pam', 'Female', 1)
Insert into tblEmployee values (4,'Todd', 'Male', 4)
Insert into tblEmployee values (5,'Sara', 'Female', 1)
Insert into tblEmployee values (6,'Ben', 'Male', 3)

With Employees_Name_Gender
as
(
 Select Id, Name, Gender from tblEmployee
)
Select * from Employees_Name_Gender

--Let's now, UPDATE JOHN's gender from Male to Female, using the Employees_Name_Gender CTE
With Employees_Name_Gender
as
(
 Select Id, Name, Gender from tblEmployee
)
Update Employees_Name_Gender Set Gender = 'Female' where Id = 1



--JOHN's gender is actually UPDATED. So, if a CTE is created on one base table, then it is possible to UPDATE the CTE, which in turn will update the underlying base table. In this case, UPDATING Employees_Name_Gender CTE, updates tblEmployee table.

--Now, let's create a CTE, on both the tables - tblEmployee and tblDepartment. The CTE should return, Employee Id, Name, Gender and Department. 


With EmployeesByDepartment
as
(
 Select Id, Name, Gender, DeptName 
 from tblEmployee
 join tblDepartment
 on tblDepartment.DeptId = tblEmployee.DepartmentId
)
Select * from EmployeesByDepartment

--Let's update this CTE. Let's change JOHN's Gender from Female to Male. Here, the CTE is based on 2 tables, but the UPDATE statement affects only one base table tblEmployee. So the UPDATE succeeds. So, if a CTE is based on more than one table, and if the UPDATE affects only one base table, then the UPDATE is allowed. 

With EmployeesByDepartment
as
(
 Select Id, Name, Gender, DeptName 
 from tblEmployee
 join tblDepartment
 on tblDepartment.DeptId = tblEmployee.DepartmentId
)
Update EmployeesByDepartment set Gender = 'Male' where Id = 1

--Now, let's try to UPDATE the CTE, in such a way, that the update affects both the tables - tblEmployee and tblDepartment. This UPDATE statement changes Gender from tblEmployee table and DeptName from tblDepartment table. When you execute this UPDATE, you get an error stating - 'View or function EmployeesByDepartment is not updatable because the modification affects multiple base tables'. So, if a CTE is based on multiple tables, and if the UPDATE statement affects more than 1 base table, then the UPDATE is not allowed.

With EmployeesByDepartment
as
(
 Select Id, Name, Gender, DeptName 
 from tblEmployee
 join tblDepartment
 on tblDepartment.DeptId = tblEmployee.DepartmentId
)
Update EmployeesByDepartment set 
Gender = 'Female', DeptName = 'IT'
where Id = 1

--Finally, let's try to UPDATE just the DeptName. Let's change JOHN's DeptName from HR to IT. Before, you execute the UPDATE statement, notice that BEN is also currently in HR department.

With EmployeesByDepartment
as
(
 Select Id, Name, Gender, DeptName 
 from tblEmployee
 join tblDepartment
 on tblDepartment.DeptId = tblEmployee.DepartmentId
)
Update EmployeesByDepartment set 
DeptName = 'HR' where Id = 1

Select * from tblDepartment
Select * from tblEmployee

--After you execute the UPDATE. Select data from the CTE, and you will see that BEN's DeptName is also changed to IT.


--This is because, when we updated the CTE, the UPDATE has actually changed the DeptName from HR to IT, in tblDepartment table, instead of changing the DepartmentId column (from 3 to 1) in tblEmployee table. So, if a CTE is based on multiple tables, and if the UPDATE statement affects only one base table, the update succeeds. But the update may not work as you expect.

/*So in short if, 
1. A CTE is based on a single base table, then the UPDATE suceeds and works as expected.
2. A CTE is based on more than one base table, and if the UPDATE affects multiple base tables, the update is not allowed and the statement terminates with an error.
3. A CTE is based on more than one base table, and if the UPDATE affects only one base table, the UPDATE succeeds(but not as expected always)*/

--A CTE that references itself is called as recursive CTE. Recursive CTE's can be of great help when displaying hierarchical data. Example, displaying employees in an organization hierarchy. A simple organization chart is shown below.

drop table if exists tblEmployee; 
Create Table tblEmployee
(
  EmployeeId int Primary key,
  Name nvarchar(20),
  ManagerId int
)

Insert into tblEmployee values (1, 'Tom', 2)
Insert into tblEmployee values (2, 'Josh', null)
Insert into tblEmployee values (3, 'Mike', 2)
Insert into tblEmployee values (4, 'John', 3)
Insert into tblEmployee values (5, 'Pam', 1)
Insert into tblEmployee values (6, 'Mary', 3)
Insert into tblEmployee values (7, 'James', 1)
Insert into tblEmployee values (8, 'Sam', 5)
Insert into tblEmployee values (9, 'Simon', 1)

--Since, a MANAGER is also an EMPLOYEE, both manager and employee details are stored in tblEmployee table.
--Let's say, we want to display, EmployeeName along with their ManagerName. 

--To achieve this, we can simply join tblEmployee with itself. Joining a table with itself is called as self join. notice that since JOSH does not have a Manager, we are displaying 'Super Boss', instead of NULL. We used IsNull(), function to replace NULL with 'Super Boss'. 

--SELF JOIN QUERY:

Select Employee.Name as [Employee Name],
IsNull(Manager.Name, 'Super Boss') as [Manager Name]
from tblEmployee Employee
left join tblEmployee Manager
on Employee.ManagerId = Manager.EmployeeId

--Along with Employee and their Manager name, we also want to display their level in the organization. We can easily achieve this using a self referencing CTE.

With
  EmployeesCTE (EmployeeId, Name, ManagerId, [Level])
  as
  (
    Select EmployeeId, Name, ManagerId, 1  --1 is hardcoded because no boss
    from tblEmployee
    where ManagerId is null
    
    union all
    
    Select tblEmployee.EmployeeId, tblEmployee.Name, 
    tblEmployee.ManagerId, EmployeesCTE.[Level] + 1
    from tblEmployee
    join EmployeesCTE
    on tblEmployee.ManagerID = EmployeesCTE.EmployeeId
  )

  select *from EmployeesCTE 

Select EmpCTE.Name as Employee, Isnull(MgrCTE.Name, 'Super Boss') as Manager, 
EmpCTE.[Level] 
from EmployeesCTE EmpCTE
left join EmployeesCTE MgrCTE
on EmpCTE.ManagerId = MgrCTE.EmployeeId

--The EmployeesCTE contains 2 queries with UNION ALL operator. The first query selects the EmployeeId, Name, ManagerId, and 1 as the level from tblEmployee where ManagerId is NULL. So, here we are giving a LEVEL = 1 for super boss (Whose Manager Id is NULL). 
--In the second query, we are joining tblEmployee with EmployeesCTE itself, which allows us to loop thru the hierarchy.

--Finally to get the reuired output, we are joining EmployeesCTE with itself. 

-==========================

CREATE TABLE sales (
  id INTEGER PRIMARY KEY,
  date DATE,
  amount DECIMAL(10, 2)
);

-- insert some sample data into the table
INSERT INTO sales (id, date, amount) VALUES
  (1, '2022-01-01', 100.00),
  (2, '2022-01-05', 200.00),
  (3, '2022-02-03', 150.00),
  (4, '2022-03-02', 300.00),
  (5, '2022-03-15', 250.00),
  (6, '2022-04-10', 200.00),
  (7, '2022-05-01', 100.00),
  (8, '2022-05-20', 150.00),
  (9, '2022-06-12', 250.00),
  (10, '2022-06-25', 300.00);

-- use a CTE to calculate the total sales for each month and find the average of those totals
WITH monthly_sales AS (
  SELECT MONTH(date) AS month, SUM(amount) AS total_sales
  FROM sales
  GROUP BY MONTH(date)
)
SELECT AVG(total_sales) AS avg_monthly_sales
FROM monthly_sales;

--Finally, we use a CTE called "monthly_sales" to select the month and total sales for each month by grouping the sales data by the month. We then use the CTE in the outer SELECT statement to calculate the average of the total sales for each month.

--Note that we don't need to use the CTE keyword in the outer SELECT statement, since the CTE is already defined in the WITH clause. We can simply refer to the CTE by name (in this case, "monthly_sales").

https://www.youtube.com/watch?v=MHCBLS0ZgIE
https://www.youtube.com/watch?v=QNfnuK-1YYY

WITH cte_name (column_names)   
AS (query)     
SELECT * FROM cte_name;    


WITH   
   cte_name1 (column_names) AS (query),  
   cte_name2 (column_names) AS (query)  
SELECT * FROM cte_name  
UNION ALL  
SELECT * FROM cte_name;



NOTE: The multiple CTE definition can be defined using UNION, UNION ALL, JOIN, INTERSECT, or EXCEPT.

https://platform.stratascratch.com/coding/10302-distance-per-dollar?code_type=1
https://towardsdatascience.com/sql-for-data-analysis-subquery-vs-cte-699ef629d9eb
