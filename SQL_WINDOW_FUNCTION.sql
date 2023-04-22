--Window functions: These functions allow you to perform calculations over a window of rows, rather than just on a single row at a time. Some examples of window functions include RANK, ROW_NUMBER, and LAG/LEAD.
--Aggregate functions with GROUP BY: Functions such as SUM, COUNT, AVG, MAX, and MIN can be used to perform calculations on groups of rows that share a common value in a certain column.
--Pivoting: Pivoting allows you to convert rows into columns, and columns into rows. This can be useful for displaying data in a different format, or for performing calculations across different dimensions.
--Subqueries: A subquery is a query that is nested inside another query. They can be used for many different purposes, such as filtering data, performing calculations, or joining tables.
--Common table expressions (CTEs): CTEs allow you to define a temporary result set that can be used within a larger query. They can simplify complex queries and make them easier to read and understand.
--String functions: SQL provides many functions for working with text data, such as CONCAT, SUBSTRING, REPLACE, and TRIM. These functions can be used to manipulate text in various ways, such as removing whitespace or formatting data.
--Overall, SQL offers a wide range of advanced functions that can be used to manipulate and analyze data in many different ways, making it a powerful tool for data analysis and management.
--https://www.docs.teradata.com/r/Teradata-VantageTM-SQL-Data-Manipulation-Language/March-2019/Select-Statements/Specifying-Subqueries-in-Search-Conditions
--https://www.youtube.com/watch?v=TzsrO4zTQj8
//**In SQL Server we have different categories of window functions
Aggregate functions - AVG, SUM, COUNT, MIN, MAX etc.. done
Ranking functions - RANK, DENSE_RANK, ROW_NUMBER etc..
Analytic functions - LEAD, LAG, FIRST_VALUE, LAST_VALUE etc..**//

--21 april 2023
drop table if exists Employees;
CREATE TABLE Employees (
    Id int primary key,
    FName varchar(255),
    Gender varchar(255),
    Salary int 
    
);
 INSERT INTO Employees(Id,FName, Gender, Salary)
 VALUES (1,'jolly', 'F', 100),(2,'Ram', 'M', 200),(3,'Sita', 'F', 300),(4,'Hanuman', 'M', 400);
 
 -- the above query does not produce the overall salary average.
 --It produces the average of the current row and the rows preceeding the current row
SELECT FName, Gender, Salary,
        AVG(Salary) OVER(ORDER BY Salary) AS Average,
		Count(Salary) OVER(ORDER BY Salary) AS cnt,
		Sum (Salary) OVER(ORDER BY Salary) AS [sum]

FROM Employees


-- problem fixed by using unbounded
SELECT FName, Gender, Salary,
   AVG(Salary) OVER(ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Average,
   Count(Salary) OVER(ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS cnt,
   Sum (Salary) OVER(ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [sum]

FROM Employees

SELECT FName, Gender, Salary,
   AVG(Salary) OVER(Partition by Gender ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Average,
   Count(Salary) OVER(Partition by Gender ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS cnt,
   Sum (Salary) OVER(Partition by Gender ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [sum]

FROM Employees

-- range is same as rows same result
SELECT FName, Gender, Salary,
   AVG(Salary) OVER(ORDER BY Salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Average,
   Count(Salary) OVER(ORDER BY Salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS cnt,
   Sum (Salary) OVER(ORDER BY Salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [sum]

FROM Employees

-- (100+200)/2=150, (100+200+300)/3=200,(200+300+400)/3=300,(300+400)/2=350
--(100+200)=300, (100+200+300)=600, (200+300+400)=900, (300+400)=700
SELECT FName, Gender, Salary,
   AVG(Salary) OVER(ORDER BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS Average,
   Count(Salary) OVER(ORDER BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS cnt,
   Sum (Salary) OVER(ORDER BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS [sum]

FROM Employees

---range & rows , no duplicates no differnce

SELECT FName, Salary, 
  SUM(Salary) OVER(ORDER BY Salary) AS [Default],
  SUM(Salary) OVER(ORDER BY Salary RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [Range],
  SUM(Salary) OVER(ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [Rows]
FROM Employees

---range & rows , if duplicates so differnce
Update Employees set Salary =100 where Id = 2

--ROWS treat duplicates as distinct values, where as RANGE treats them as a single entity.
SELECT FName, Salary, 
  SUM(Salary) OVER(ORDER BY Salary) AS [Default],
  SUM(Salary) OVER(ORDER BY Salary RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [Range],
  SUM(Salary) OVER(ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [Rows]
FROM Employees

-----a query to retrieve total count of employees by Gender
SELECT Gender, COUNT(*) AS GenderTotal, AVG(Salary) AS AvgSal,
        MIN(Salary) AS MinSal, MAX(Salary) AS MaxSal
FROM Employees
GROUP BY Gender

--- You cannot include non-aggregated columns in the GROUP BY query.
--- Employees.FName' is invalid in the select list because it is not contained 
--- in either an aggregate function or the GROUP BY clause.

SELECT FName, Salary, Gender, COUNT(*) AS GenderTotal, AVG(Salary) AS AvgSal,
        MIN(Salary) AS MinSal, MAX(Salary) AS MaxSal
FROM Employees
GROUP BY Gender

--One way to achieve this is by including the aggregations in a subquery 
--and then JOINING it with the main query as shown in the example below.

SELECT FName, Salary, Employees.Gender, Genders.GenderTotals,
        Genders.AvgSal, Genders.MinSal, Genders.MaxSal   
FROM Employees
INNER JOIN
(SELECT Gender, COUNT(*) AS GenderTotals,
          AVG(Salary) AS AvgSal,
         MIN(Salary) AS MinSal, MAX(Salary) AS MaxSal
FROM Employees
GROUP BY Gender) Genders
ON Genders.Gender = Employees.Gender

--Better way of doing this is by using the OVER clause combined with PARTITION BY
SELECT FName, Salary, Gender,
        COUNT(Gender) OVER(PARTITION BY Gender) AS GenderTotals,
        AVG(Salary) OVER(PARTITION BY Gender) AS AvgSal,
        MIN(Salary) OVER(PARTITION BY Gender) AS MinSal,
        MAX(Salary) OVER(PARTITION BY Gender) AS MaxSal
FROM Employees

/*Row_Number function without PARTITION BY : In this example, data is not partitioned,
so ROW_NUMBER will provide a consecutive numbering for all the rows in the table based on
the order of rows imposed by the ORDER BY clause. */

-- row number required order by
SELECT FName, Gender, Salary,
        ROW_NUMBER() OVER (ORDER BY Gender) AS RowNumber
FROM Employees

/*Row_Number function with PARTITION BY : In this example, data is partitioned by Gender, 
so ROW_NUMBER will provide a consecutive numbering only for the rows with in a parttion. 
When the partition changes the row number is reset to 1.*/

SELECT FName, Gender, Salary,
        ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY Gender) AS RowNumber
FROM Employees

--https://www.youtube.com/watch?v=5-La_uSNkKU&list=PL08903FB7ACA1C2FB&index=111

--Rank and Dense Rank in SQL Server Difference between Rank and Dense_Rank functions
--Rank function skips ranking(s) if there is a tie where as Dense_Rank will not.
--RANK() and DENSE_RANK() functions without PARTITION BY clause :
drop table if exists Employees;
CREATE TABLE Employees (
    Id int primary key,
    FName varchar(255),
    Gender varchar(255),
    Salary int 
    
);
INSERT INTO Employees(Id,FName, Gender, Salary)
 VALUES (1,'jolly', 'F', 100),(2,'Ram', 'M', 200),(3,'Sita', 'F', 300),(4,'Gita', 'F', 300),(5,'Hanuman', 'M', 400);

SELECT FName, Salary, Gender,
RANK() OVER (ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees

--RANK() and DENSE_RANK() functions with PARTITION BY clause : Notice when the partition changes from Female to Male Rank is reset to 1

SELECT FName, Salary, Gender,
RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC) AS DenseRank
FROM Employees

--If your business case is, not to produce any result for the SECOND highest salary if tie , then use RANK function
--If your business case is to return the next Salary after the tied rows as the SECOND highest Salary, then use DENSE_RANK function

WITH Result AS
(
    SELECT Salary, RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
    FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 3

WITH Result AS
(
    SELECT Gender, Salary, RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC) AS Salary_Rank
    FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2 AND Gender = 'F'

/*You can also use RANK and DENSE_RANK functions to find the Nth highest Salary among Male or Female employee groups. The following query finds the 3rd highest salary amount paid among the Female employees group */

WITH Result1 AS
(
    SELECT Salary, Gender,
           DENSE_RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC) AS Salary_Rank
    FROM Employees
)
SELECT TOP 1 Salary FROM Result1 WHERE Salary_Rank = 2 AND Gender = 'F'

/*a. all the 3 functions RANK, DENSE_RANK and ROW_NUMBER produce the same increasing integer value when ordered by Salary column.*/

/* b.  difference when there ties (duplicate values in the column used in the ORDER BY clause).*/
drop table if exists Employees;
CREATE TABLE Employees (
    Id int primary key,
    FName varchar(255),
    Gender varchar(255),
    Salary int 
    
);
Insert Into Employees Values (1, 'Mark', 'Male', 6000)
Insert Into Employees Values (2, 'John', 'Male', 8000)
Insert Into Employees Values (3, 'Pam', 'Female', 4000)
Insert Into Employees Values (4, 'Sara', 'Female', 5000)
Insert Into Employees Values (5, 'Todd', 'Male', 3000)

--a. same ranking 
SELECT FName, Salary, Gender,
ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumber,
RANK() OVER (ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees

b-- different rankings when duplicate values
--First delete existing data from the Employees table
DELETE FROM Employees

--Insert new rows with duplicate valuse for Salary column
Insert Into Employees Values (1, 'Mark', 'Male', 8000)
Insert Into Employees Values (2, 'John', 'Male', 8000)
Insert Into Employees Values (3, 'Pam', 'Female', 8000)
Insert Into Employees Values (4, 'Sara', 'Female', 4000)
Insert Into Employees Values (5, 'Todd', 'Male', 3500)

SELECT FName, Salary, Gender,
ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumber,
RANK() OVER (ORDER BY Salary DESC) AS [Rank],
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees

/*FIRST_VALUE function example WITHOUT partitions : 
In the following example, FIRST_VALUE function returns the name of the lowest paid employee from the entire table.*/
DELETE FROM Employees
Insert Into Employees Values (1, 'Mark', 'Male', 6000)
Insert Into Employees Values (2, 'John', 'Male', 8000)
Insert Into Employees Values (3, 'Pam', 'Female', 4000)
Insert Into Employees Values (4, 'Sara', 'Female', 5000)
Insert Into Employees Values (5, 'Todd', 'Male', 3000)

SELECT FName, Gender, Salary,
  FIRST_VALUE(FName) OVER (ORDER BY Salary) AS FirstValue
FROM Employees

/*FIRST_VALUE function example WITH partitions : In the following example, FIRST_VALUE function returns the name of the lowest paid employee from the respective partition.*/

SELECT FName, Gender, Salary,
  FIRST_VALUE(FName) OVER (PARTITION BY Gender ORDER BY Salary) AS FirstValue
FROM Employees

/*LAST_VALUE function not working as expected : In the following example, LAST_VALUE function does not return the name of the highest paid employee. This is because we have not specified an explicit value for ROWS or RANGE clause. As a result it is using it's default value RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.*/

SELECT FName, Gender, Salary,
    LAST_VALUE(FName) OVER (ORDER BY Salary) AS LastValue
FROM Employees

LAST_VALUE function working as expected : In the following example, LAST_VALUE function returns the name of the highest paid employee as expected. Notice we have set an explicit value for ROWS or RANGE clause to ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

/*This tells the LAST_VALUE function that it's window starts at the first row and ends at the last row in the result set.*/

SELECT FName, Gender, Salary,
    LAST_VALUE(FName) OVER (ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastValue
FROM Employees

/*LAST_VALUE function example with partitions : In the following example, LAST_VALUE function returns the name of the highest paid employee from the respective partition.*/

SELECT FName, Gender, Salary,
    LAST_VALUE(FName) OVER (PARTITION BY Gender ORDER BY Salary
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastValue
FROM Employees

/*Lead and Lag functions 
Introduced in SQL Server 2012
Lead function is used to access subsequent row data along with current row data
Lag function is used to access previous row data along with current row data
ORDER BY clause is required
PARTITION BY clause is optional */

SELECT FName, Gender, Salary,
        
		LEAD(Salary) OVER (ORDER BY Salary) AS Lead_2,
        LAG(Salary) OVER (ORDER BY Salary) AS Lag_1
FROM Employees
/*Lead and Lag functions example WITHOUT partitions : This example Leads 2 rows and Lags 1 row from the current row.
When you are on the first row, LEAD(Salary, 2, -1) allows you to move forward 2 rows and retrieve the salary from the 3rd row.*/

SELECT FName, Gender, Salary,
        LEAD (Salary, 2, -1) OVER (ORDER BY Salary) AS Lead_2,
		LAG (Salary, 1, -1) OVER (ORDER BY Salary) AS Lag_1
FROM Employees

/*Lead and Lag functions example WITH partitions : Notice that in this example, Lead and Lag functions return default value if the number of rows to lead or lag goes beyond first row or last row in the partition.  Syntax
LEAD(Column_Name, Offset, Default_Value) OVER (ORDER BY Col1, Col2, ...)
LAG(Column_Name, Offset, Default_Value) OVER (ORDER BY Col1, Col2, ...)*/

SELECT FName, Gender, Salary,
        LEAD(Salary, 2, -1) OVER (PARTITION By Gender ORDER BY Salary) AS Lead_2,
        LAG(Salary, 1, -1) OVER (PARTITION By Gender ORDER BY Salary) AS Lag_1
FROM Employees
