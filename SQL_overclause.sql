/**Over clause in SQL Server**/

/*The OVER clause combined with PARTITION BY is used to break up data into partitions 
Syntax : function (...) OVER (PARTITION BY col1, Col2, ...)
The specified function operates for each partition.
COUNT(Gender) OVER (PARTITION BY Gender) will partition the data by GENDER i.e there will 2 partitions (Male and Female) and then the COUNT() function is applied over each partition.

Any of the following functions can be used. Please note this is not the complete list.
COUNT(), AVG(), SUM(), MIN(), MAX(), ROW_NUMBER(), RANK(), DENSE_RANK() etc.*/

drop table if exists EmployeesJ1;
Create Table EmployeesJ1
(
     Id int primary key,
     [Name] nvarchar(50),
     Gender nvarchar(10),
     Salary int
)
Go

Insert Into EmployeesJ1 Values (1, 'Mark', 'Male', 5000)
Insert Into EmployeesJ1 Values (2, 'John', 'Male', 4500)
Insert Into EmployeesJ1 Values (3, 'Pam', 'Female', 5500)
Insert Into EmployeesJ1 Values (4, 'Sara', 'Female', 4000)
Insert Into EmployeesJ1 Values (5, 'Todd', 'Male', 3500)
Insert Into EmployeesJ1 Values (6, 'Mary', 'Female', 5000)
Insert Into EmployeesJ1 Values (7, 'Ben', 'Male', 6500)
Insert Into EmployeesJ1 Values (8, 'Jodi', 'Female', 7000)
Insert Into EmployeesJ1 Values (9, 'Tom', 'Male', 5500)
Insert Into EmployeesJ1 Values (10, 'Ron', 'Male', 5000)
Go

--Write a query to retrieve total count of employees by Gender. Also in the result we want Average, Minimum and Maximum salary by Gender. The result of the query should be as shown below.
--sql server group by min max

SELECT Gender, COUNT(*) AS GenderTotal, AVG(Salary) AS AvgSal,
        MIN(Salary) AS MinSal, MAX(Salary) AS MaxSal
FROM EmployeesJ1
GROUP BY Gender

--What if we want non-aggregated values (like employee Name and Salary) in result set along with aggregated values
--non-aggregate columns in a group by query
--You cannot include non-aggregated columns in the GROUP BY query.

SELECT [Name], Salary, Gender, COUNT(*) AS GenderTotal, AVG(Salary) AS AvgSal,
        MIN(Salary) AS MinSal, MAX(Salary) AS MaxSal
FROM EmployeesJ1
GROUP BY Gender

--The above query will result in the following error
--Column 'Employees.Name' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause

--One way to achieve this is by including the aggregations in a subquery and then JOINING it with the main query as shown in the example below. Look at the amount of T-SQL code we have to write.

SELECT [Name], Salary, EmployeesJ1.Gender, Genders.GenderTotals,
        Genders.AvgSal, Genders.MinSal, Genders.MaxSal   
FROM EmployeesJ1
INNER JOIN
(SELECT Gender, COUNT(*) AS GenderTotals,
          AVG(Salary) AS AvgSal,
         MIN(Salary) AS MinSal, MAX(Salary) AS MaxSal
FROM EmployeesJ1
GROUP BY Gender) AS Genders
ON Genders.Gender = EmployeesJ1.Gender

--Better way of doing this is by using the OVER clause combined with PARTITION BY

SELECT [Name], Salary, Gender,
        COUNT(Gender) OVER(PARTITION BY Gender) AS GenderTotals,
        AVG(Salary) OVER(PARTITION BY Gender) AS AvgSal,
        MIN(Salary) OVER(PARTITION BY Gender) AS MinSal,
        MAX(Salary) OVER(PARTITION BY Gender) AS MaxSal
FROM EmployeesJ1

--Row_Number function in SQL Server
--ORDER BY clause is required
--PARTITION BY clause is optional

--When the data is partitioned, row number is reset to 1 when the partition changes
--Syntax : ROW_NUMBER() OVER (ORDER BY Col1, Col2)

--Row_Number function without PARTITION BY : In this example, data is not partitioned, so ROW_NUMBER will provide a consecutive numbering for all the rows in the table based on the order of rows imposed by the ORDER BY clause.

SELECT [Name], Gender, Salary,
        ROW_NUMBER() OVER (ORDER BY Gender) AS RowNumber
FROM EmployeesJ1


--Please note : If ORDER BY clause is not specified you will get the following error
--The function 'ROW_NUMBER' must have an OVER clause with ORDER BY

--Row_Number function with PARTITION BY : In this example, data is partitioned by Gender, so ROW_NUMBER will provide a consecutive numbering only for the rows with in a parttion. When the partition changes the row number is reset to 1.

SELECT [Name], Gender, Salary,
        ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY Gender) AS RowNumber
FROM EmployeesJ1


--Use case for Row_Number function : Deleting all duplicate rows except one from a sql server table. 

drop table if exists EmployeesJ2;
Create table EmployeesJ2
(
 ID int,
 FirstName nvarchar(50),
 LastName nvarchar(50),
 Gender nvarchar(50),
 Salary int
)
GO

Insert into EmployeesJ2 values (1, 'Mark', 'Hastings', 'Male', 60000)
Insert into EmployeesJ2 values (1, 'Mark', 'Hastings', 'Male', 60000)
Insert into EmployeesJ2 values (1, 'Mark', 'Hastings', 'Male', 60000)
Insert into EmployeesJ2 values (2, 'Mary', 'Lambeth', 'Female', 30000)
Insert into EmployeesJ2 values (2, 'Mary', 'Lambeth', 'Female', 30000)
Insert into EmployeesJ2 values (3, 'Ben', 'Hoskins', 'Male', 70000)
Insert into EmployeesJ2 values (3, 'Ben', 'Hoskins', 'Male', 70000)
Insert into EmployeesJ2 values (3, 'Ben', 'Hoskins', 'Male', 70000)

--The delete query should delete all duplicate rows except one. 

--Here is the SQL query that does the job. PARTITION BY divides the query result set into partitions.
SELECT * FROM EmployeesJ2 --(total 8 lines: )

WITH EmployeesCTE AS
(
   SELECT *, ROW_NUMBER()OVER(PARTITION BY ID ORDER BY ID) AS RowNumber
   FROM EmployeesJ2 -- total 8, 8-5=3   id-1,2,3
)
SELECT * FROM EmployeesJ2
-------------------------

WITH EmployeesCTE AS
(
   SELECT *, ROW_NUMBER()OVER(PARTITION BY ID ORDER BY ID) AS RowNumber
   FROM EmployeesJ2 -- total 8, 8-5=3   id-1,2,3
)

DELETE FROM EmployeesCTE WHERE RowNumber > 1
SELECT * FROM EmployeesJ2

--Rank and Dense_Rank functions
--Returns a rank starting at 1 based on the ordering of rows imposed by the ORDER BY clause
--ORDER BY clause is required
--PARTITION BY clause is optional
--When the data is partitioned, rank is reset to 1 when the partition changes
--Difference between Rank and Dense_Rank functions
--Rank function skips ranking(s) if there is a tie where as Dense_Rank will not.

For example : If you have 2 rows at rank 1 and you have 5 rows in total.
RANK() returns - 1, 1, 3, 4, 5
DENSE_RANK returns - 1, 1, 2, 3, 4

Syntax : 
RANK() OVER (ORDER BY Col1, Col2, ...)
DENSE_RANK() OVER (ORDER BY Col1, Col2, ...)


--SQl Script to create Employees table
drop table if exists EmployeesJ2;
Create Table EmployeesJ2
(
    Id int primary key,
    [Name] nvarchar(50),
    Gender nvarchar(10),
    Salary int
)
Go

Insert Into EmployeesJ2 Values (1, 'Mark', 'Male', 8000)
Insert Into EmployeesJ2 Values (2, 'John', 'Male', 8000)
Insert Into EmployeesJ2 Values (3, 'Pam', 'Female', 5000)
Insert Into EmployeesJ2 Values (4, 'Sara', 'Female', 4000)
Insert Into EmployeesJ2 Values (5, 'Todd', 'Male', 3500)
Insert Into EmployeesJ2 Values (6, 'Mary', 'Female', 6000)
Insert Into EmployeesJ2 Values (7, 'Ben', 'Male', 6500)
Insert Into EmployeesJ2 Values (8, 'Jodi', 'Female', 4500)
Insert Into EmployeesJ2 Values (9, 'Tom', 'Male', 7000)
Insert Into EmployeesJ2 Values (10, 'Ron', 'Male', 6800)
Go

--RANK() and DENSE_RANK() functions without PARTITION BY clause : In this example, data is not partitioned, so RANK() function provides a consecutive numbering except when there is a tie. Rank 2 is skipped as there are 2 rows at rank 1. The third row gets rank 3.

--DENSE_RANK() on the other hand will not skip ranks if there is a tie. The first 2 rows get rank 1. Third row gets rank 2.

SELECT Name, Salary, Gender,
RANK() OVER (ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM EmployeesJ2 

--difference between rank and dense_rank with example

RANK() and DENSE_RANK() functions with PARTITION BY clause : Notice when the partition changes from Female to Male Rank is reset to 1

SELECT [Name], Salary, Gender,
RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC)
AS DenseRank
FROM EmployeesJ2 

--Use case for RANK and DENSE_RANK functions : Both these functions can be used to find Nth highest salary. However, which function to use depends on what you want to do when there is a tie. Let me explain with an example.

--If there are 2 employees with the FIRST highest salary, there are 2 different business cases
--If your business case is, not to produce any result for the SECOND highest salary, then use RANK function

--If your business case is to return the next Salary after the tied rows as the SECOND highest Salary, then use DENSE_RANK function
--Since we have 2 Employees with the FIRST highest salary. Rank() function will not return any rows for the SECOND highest Salary.

WITH Result AS
(
    SELECT Salary, RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
    FROM EmployeesJ2 
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2

--Though we have 2 Employees with the FIRST highest salary. Dense_Rank() function returns, the next Salary after the tied rows as the SECOND highest Salary

WITH Result AS
(
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
    FROM EmployeesJ2 
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2

--You can also use RANK and DENSE_RANK functions to find the Nth highest Salary among Male or Female employee groups. The following query finds the 3rd highest salary amount paid among the Female employees group

WITH Result AS
(
    SELECT Salary, Gender,
           DENSE_RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC)
           AS Salary_Rank
    FROM EmployeesJ2 
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 3
AND Gender = 'Female'

--Similarities between RANK, DENSE_RANK and ROW_NUMBER functions
--Returns an increasing integer value starting at 1 based on the ordering of rows imposed by the ORDER BY clause (if there are no ties)
--ORDER BY clause is required
--PARTITION BY clause is optional
--When the data is partitioned, the integer value is reset to 1 when the partition changes

drop table if exists EmployeesJ2;
Create Table EmployeesJ2 
(
     Id int primary key,
     Name nvarchar(50),
     Gender nvarchar(10),
     Salary int
)
Go

Insert Into EmployeesJ2 Values (1, 'Mark', 'Male', 6000)
Insert Into EmployeesJ2 Values (2, 'John', 'Male', 8000)
Insert Into EmployeesJ2 Values (3, 'Pam', 'Female', 4000)
Insert Into EmployeesJ2 Values (4, 'Sara', 'Female', 5000)
Insert Into EmployeesJ2 Values (5, 'Todd', 'Male', 3000)

--Notice that no two employees in the table have the same salary. So all the 3 functions RANK, DENSE_RANK and ROW_NUMBER produce the same increasing integer value when ordered by Salary column.

SELECT Name, Salary, Gender,
ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumber,
RANK() OVER (ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM EmployeesJ2;

--row_number vs rank vs dense_rank in sql server

--You will only see the difference when there ties (duplicate values in the column used in the ORDER BY clause).

--Now let's include duplicate values for Salary column. 

--First delete existing data from the Employees table
DELETE FROM EmployeesJ2

Insert Into EmployeesJ2 Values (1, 'Mark', 'Male', 8000)
Insert Into EmployeesJ2 Values (2, 'John', 'Male', 8000)
Insert Into EmployeesJ2 Values (3, 'Pam', 'Female', 8000)
Insert Into EmployeesJ2 Values (4, 'Sara', 'Female', 4000)
Insert Into EmployeesJ2 Values (5, 'Todd', 'Male', 3500)


--Notice 3 employees have the same salary 8000. When you execute the following query you can clearly see the difference between RANK, DENSE_RANK and ROW_NUMBER functions.

SELECT Name, Salary, Gender,
ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumber,
RANK() OVER (ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM EmployeesJ2

--dense_rank vs rank vs row_number sql server

--Difference between RANK, DENSE_RANK and ROW_NUMBER functions

ROW_NUMBER : Returns an increasing unique number for each row starting at 1, even if there are duplicates.

RANK : Returns an increasing unique number for each row starting at 1. When there are duplicates, same rank is assigned to all the duplicate rows, but the next row after the duplicate rows will have the rank it would have been assigned if there had been no duplicates. So RANK function skips rankings if there are duplicates.

DENSE_RANK : Returns an increasing unique number for each row starting at 1. When there are duplicates, same rank is assigned to all the duplicate rows but the DENSE_RANK function will not skip any ranks. This means the next row after the duplicate rows will have the next rank in the sequence.

drop table if exists EmployeesJ2;
Create Table EmployeesJ2
(
 Id int primary key,
 Name nvarchar(50),
 Gender nvarchar(10),
 Salary int
)
Go

Insert Into EmployeesJ2 Values (1, 'Mark', 'Male', 5000)
Insert Into EmployeesJ2 Values (2, 'John', 'Male', 4500)
Insert Into EmployeesJ2 Values (3, 'Pam', 'Female', 5500)
Insert Into EmployeesJ2 Values (4, 'Sara', 'Female', 4000)
Insert Into EmployeesJ2 Values (5, 'Todd', 'Male', 3500)
Insert Into EmployeesJ2 Values (6, 'Mary', 'Female', 5000)
Insert Into EmployeesJ2 Values (7, 'Ben', 'Male', 6500)
Insert Into EmployeesJ2 Values (8, 'Jodi', 'Female', 7000)
Insert Into EmployeesJ2 Values (9, 'Tom', 'Male', 5500)
Insert Into EmployeesJ2 Values (10, 'Ron', 'Male', 5000)
Go

--SQL Query to compute running total without partitions
SELECT Name, Gender, Salary, 
    SUM(Salary) OVER (ORDER BY ID) AS RunningTotal
FROM EmployeesJ2

--SQL Query to compute running total with partitions
SELECT Name, Gender, Salary, 
    SUM(Salary) OVER (PARTITION BY Gender ORDER BY ID) AS RunningTotal
FROM EmployeesJ2

--What happens if I use order by on Salary column
--If you have duplicate values in the Salary column, all the duplicate values will be added to the running total at once. In the example below notice that we have 5000 repeated 3 times. So 15000 (i.e 5000 + 5000 + 5000) is added to the running total at once. 

SELECT Name, Gender, Salary, 
    SUM(Salary) OVER (ORDER BY Salary) AS RunningTotal
FROM EmployeesJ2

--So when computing running total, it is better to use a column that has unique data in the ORDER BY clause.

--NTILE function 
ORDER BY Clause is required
PARTITION BY clause is optional
Distributes the rows into a specified number of groups
If the number of rows is not divisible by number of groups, you may have groups of two different sizes.
Larger groups come before smaller groups


--NTILE(2) of 10 rows divides the rows in 2 Groups (5 in each group)
--NTILE(3) of 10 rows divides the rows in 3 Groups (4 in first group, 3 in 2nd & 3rd group)
--Syntax : NTILE (Number_of_Groups) OVER (ORDER BY Col1, Col2, ...)

drop table if exists EmployeesJ2;
Create Table EmployeesJ2
(
    Id int primary key,
    Name nvarchar(50),
    Gender nvarchar(10),
    Salary int
)
Go

Insert Into EmployeesJ2 Values (1, 'Mark', 'Male', 5000)
Insert Into EmployeesJ2 Values (2, 'John', 'Male', 4500)
Insert Into EmployeesJ2 Values (3, 'Pam', 'Female', 5500)
Insert Into EmployeesJ2 Values (4, 'Sara', 'Female', 4000)
Insert Into EmployeesJ2 Values (5, 'Todd', 'Male', 3500)
Insert Into EmployeesJ2 Values (6, 'Mary', 'Female', 5000)
Insert Into EmployeesJ2 Values (7, 'Ben', 'Male', 6500)
Insert Into EmployeesJ2 Values (8, 'Jodi', 'Female', 7000)
Insert Into EmployeesJ2 Values (9, 'Tom', 'Male', 5500)
Insert Into EmployeesJ2 Values (10, 'Ron', 'Male', 5000)
Go

--NTILE function without PARTITION BY clause : Divides the 10 rows into 3 groups. 4 rows in first group, 3 rows in the 2nd & 3rd group.

SELECT Name, Gender, Salary,
NTILE(3) OVER (ORDER BY Salary) AS [Ntile]
FROM EmployeesJ2


--What if the specified number of groups is GREATER THAN the number of rows
--NTILE function will try to create as many groups as possible with one row in each group. 

--With 10 rows in the table, NTILE(11) will create 10 groups with 1 row in each group.

SELECT Name, Gender, Salary,
NTILE(11) OVER (ORDER BY Salary) AS [Ntile]
FROM EmployeesJ2

--NTILE function with PARTITION BY clause : When the data is partitioned, NTILE function creates the specified number of groups with in each partition.

--The following query partitions the data into 2 partitions (Male & Female). NTILE(3) creates 3 groups in each of the partitions.

SELECT Name, Gender, Salary,
NTILE(3) OVER (PARTITION BY GENDER ORDER BY Salary) AS [Ntile]
FROM EmployeesJ2

--Lead and Lag functions
LEAD(Column_Name, Offset, Default_Value) OVER (ORDER BY Col1, Col2, ...)
LAG(Column_Name, Offset, Default_Value) OVER (ORDER BY Col1, Col2, ...)

Offset - Number of rows to lead or lag.
Default_Value - The default value to return if the number of rows to lead or lag goes beyond first row or last row in a table or partition. If default value is not specified NULL is returned.

drop table if exists EmployeesJ2;
Create Table EmployeesJ2
(
 Id int primary key,
 Name nvarchar(50),
 Gender nvarchar(10),
 Salary int
)
Go

Insert Into EmployeesJ2 Values (1, 'Mark', 'Male', 1000)
Insert Into EmployeesJ2 Values (2, 'John', 'Male', 2000)
Insert Into EmployeesJ2 Values (3, 'Pam', 'Female', 3000)
Insert Into EmployeesJ2 Values (4, 'Sara', 'Female', 4000)
Insert Into EmployeesJ2 Values (5, 'Todd', 'Male', 5000)
Insert Into EmployeesJ2 Values (6, 'Mary', 'Female', 6000)
Insert Into EmployeesJ2 Values (7, 'Ben', 'Male', 7000)
Insert Into EmployeesJ2 Values (8, 'Jodi', 'Female', 8000)
Insert Into EmployeesJ2 Values (9, 'Tom', 'Male', 9000)
Insert Into EmployeesJ2 Values (10, 'Ron', 'Male', 9500)
Go

--Lead and Lag functions example WITHOUT partitions : This example Leads 2 rows and Lags 1 row from the current row. 

--When you are on the first row, LEAD(Salary, 2, -1) allows you to move forward 2 rows and retrieve the salary from the 3rd row.
--When you are on the first row, LAG(Salary, 1, -1) allows us to move backward 1 row. Since there no rows beyond row 1, Lag function in this case returns the default value -1.

--When you are on the last row, LEAD(Salary, 2, -1) allows you to move forward 2 rows. Since there no rows beyond the last row 1, Lead function in this case returns the default value -1.
--When you are on the last row, LAG(Salary, 1, -1) allows us to move backward 1 row and retrieve the salary from the previous row.

SELECT Name, Gender, Salary, 
    LEAD(Salary, 2, -1) OVER (ORDER BY Salary) AS Lead_2,
    LAG(Salary, 1, -1) OVER (ORDER BY Salary) AS Lag_1
FROM EmployeesJ2

--Lead and Lag functions example WITH partitions : Notice that in this example, Lead and Lag functions return default value if the number of rows to lead or lag goes beyond first row or last row in the partition. 

SELECT Name, Gender, Salary, 
    LEAD(Salary, 2, -1) OVER (PARTITION By Gender ORDER BY Salary) AS Lead_2,
    LAG(Salary, 1, -1) OVER (PARTITION By Gender ORDER BY Salary) AS Lag_1
FROM EmployeesJ2


--The GUID data type is a 16 byte binary data type that is globally unique. GUID stands for Global Unique Identifier. The terms GUID and UNIQUEIDENTIFIER are used interchangeably.

--To declare a GUID variable, we use the keyword UNIQUEIDENTIFIER

Declare @ID UNIQUEIDENTIFIER
SELECT @ID = NEWID()
SELECT @ID as MYGUID
--------------------------------
 Select NEWID()
--How to create GUID in sql server
--To create a GUID in SQL Server use NEWID() function

--For example, SELECT NEWID(), creates a GUID that is guaranteed to be unique across tables, databases, and servers. Every time you execute SELECT NEWID() query, you get a GUID that is unique.

Example GUID : 0BB83607-00D7-4B2C-8695-32AD3812B6F4

When to use GUID data type : Let us understand when to use a GUID in SQL Server with an example. 


--The main advantage of using a GUID is that it is unique across tables, databases and servers. It is extremely useful if you're consolidating records from multiple SQL Servers into a single table. 

--The main disadvantage of using a GUID as a key is that it is 16 bytes in size. It is one of the largest datatypes in SQL Server. An integer on the other hand is 4 bytes,

--An Index built on a GUID is larger and slower than an index built on integer column. In addition a GUID is hard to read compared to int.

--So in summary, use a GUID when you really need a globally unique identifier. In all other cases it is better to use an INT data type.

When to use GUID data type : Let us understand when to use a GUID in SQL Server with an example. 

1. Let us say our company does business in 2 countries - USA and India. 

2. USA customers are stored in a table called USACustomers in a database called USADB.

Create Database USADB
Go

Use USADB
Go
drop table if exists USACustomers;
Create Table USACustomers
(
     ID int primary key identity,
     Name nvarchar(50)
)
Go

Insert Into USACustomers Values ('Tom')
Insert Into USACustomers Values ('Mike')

Select * From USADB.dbo.USACustomers


3. India customers are stored in a table called IndiaCustomers in a database called IndiaDB.

Create Database IndiaDB
Go

Use IndiaDB
Go

drop table if exists IndiaCustomers;
Create Table IndiaCustomers
(
     ID int primary key identity,
     Name nvarchar(50)
)
Go

Insert Into IndiaCustomers Values ('Tom')
Insert Into IndiaCustomers Values ('Mike')

Select * From IndiaDB.dbo.IndiaCustomers


--In both the tables, the ID column data type is integer. It is also the primary key column which ensures the ID column across every row is unique in that table. We also have turned on the identity property,

4. Now, we want to load the customers from both countries (India & USA) in to a single existing table Customers.



--First let's create the table. Use the following SQL script to create the table. ID column is the primary key of the table.

drop table if exists Customers;
Create Table Customers
(
     ID int primary key,
     Name nvarchar(50)
)

Go

--Now execute the following script which selects the data from IndiaCustomers and USACustomers tables and inserts into Customers table

Insert Into Customers
Select * from IndiaDB.dbo.IndiaCustomers
Union All
Select * from USADB.dbo.USACustomers

--Violation of PRIMARY KEY constraint 'PK__Customer__3214EC27165BFAFF'. Cannot insert duplicate key in object 'dbo.Customers'. The duplicate key value is (1).
The statement has been terminated.
We get the following error. This is because in both the tables, Identity column data type is integer. Integer is great for identity as long as you only want to maintain the uniqueness across just that one table. However, between IndiaCustomers and USACustomers tables, the ID coulumn values are not unique. So when we load the data into Customers table, we get "Violation of PRIMARY KEY constraint" error.

Msg 2627, Level 14, State 1, Line 1
Violation of PRIMARY KEY constraint. Cannot insert duplicate key in object 'dbo.Customers'. The duplicate key value is (1).
The statement has been terminated.

A GUID on the other hand is unique across tables, databases, and servers. A GUID is guaranteed to be globally unique. Let us see if we can solve the above problem using a GUID.

Create USACustomers1 table and populate it with data. Notice ID column datatype is uniqueidentifier. To auto-generate the GUID values we are using a Default constraint.

Use USADB
Go

Create Table USACustomers1
(
     ID uniqueidentifier primary key default NEWID(),
     Name nvarchar(50)
)
Go

Insert Into USACustomers1 Values (Default, 'Tom')
Insert Into USACustomers1 Values (Default, 'Mike')

--Next, create IndiaCustomers1 table and populate it with data.

Use IndiaDB
Go

Create Table IndiaCustomers1
(
     ID uniqueidentifier primary key default NEWID(),
     Name nvarchar(50)
)
Go

Insert Into IndiaCustomers1 Values (Default, 'John')
Insert Into IndiaCustomers1 Values (Default, 'Ben')


--Select data from both the tables (USACustomers1 & IndiaCustomers1). Notice the ID column values. They are unique across both the tables.

Select * From IndiaDB.dbo.IndiaCustomers1
UNION ALL
Select * From USADB.dbo.USACustomers1

--uniqueidentifier in sql server

--Now, we want to load the customers from USACustomers1 and IndiaCustomers1 tables in to a single existing table called Customers1. Let us first create Customers1 table. The ID column in Customers1 table is uniqueidentifier.

Create Table Customers1
(
     ID uniqueidentifier primary key,
     Name nvarchar(50)
)
Go

--Finally, execute the following insert script. Notice the script executes successfully without any errors and the data is loaded into Customers1 table.

Insert Into Customers1
Select * from IndiaDB.dbo.IndiaCustomers1
Union All
Select * from USADB.dbo.USACustomers1

--The main advantage of using a GUID is that it is unique across tables, databases and servers. It is extremely useful if you're consolidating records from multiple SQL Servers into a single table. 

--The main disadvantage of using a GUID as a key is that it is 16 bytes in size. It is one of the largest datatypes in SQL Server. An integer on the other hand is 4 bytes,

--An Index built on a GUID is larger and slower than an index built on integer column. In addition a GUID is hard to read compared to int.

--So in summary, use a GUID when you really need a globally unique identifier. In all other cases it is better to use an INT data type.