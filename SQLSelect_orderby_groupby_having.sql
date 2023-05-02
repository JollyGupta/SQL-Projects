
use SQLPRACTICE

drop table if exists Details;

Create table Details
    (id int,
     name1 nvarchar(50),
	 email nvarchar(50),
	 genderid int,
	 age int,
	 city nvarchar(50)
     )

INSERT INTO Details (id ,name1 ,email,genderid,age,city )
values
(1,'Ram','r@gmail.com',1,30, 'london'),(2, 'Sita','s@gmail.com', 2,29, 'london'),
(3,'Hanuman','h@gmail.com' ,1,19, 'Newyork'),(4,'radha','r@gmail.com',2,20, 'Sydney'),
(5, 'Krishna','k@gmail.com',1,21, 'canada'),
(6,'Jolly','gupta.jolly28@gmail.com',2,39 ,'mumbai'),(7,'Jolly','gupta.jolly28@gmail.com',2,45 ,'canada');

--1. Select specific or all columns
select * from Details
select city from  Details 

--2. Distinct rows
SELECT DISTINCT city
FROM Details 

SELECT DISTINCT name1,city
FROM Details

--3. Filtering with where clause.

Select name1, Email from Details where city = 'London'
Select *from Details where age=20 or age=29 or age=39
Select *from Details where age IN (20,29,39)
Select *from Details where age between 20 and 39

--4. Wild Cards in SQL Server
Select *from Details where city Like 'L%'
Select *from Details where email Like '%@%'
Select *from Details where email  Like '-@-.com' --not working
Select *from Details where email  not Like '-@-.com'
Select *from Details where name1 Like '[RSH]%'

--5. Joining multiple conditions using AND and OR operators
Select *from Details where (city='london' or city='mumbai') and age>10

--6. Sorting rows using order by
Select *from Details 
--order by name1 asc
order by name1 desc

Select *from Details 
order by name1 desc, age asc --same name jolly, within same name age in ascending order

--7. Selecting top n or top n percentage of rows
select top 10 * from Details
select top 2 name1, age from Details
select top 1 percent  name1, age from Details
select top 50 percent  name1, age from Details

------------------------------------------------------------------
--Group By  aggregate functions. 
/* 1. Count()
2. Sum()
3. avg()
4. Min()
5. Max()*/

/*Group by clause is used to group a selected set of rows into a set of summary rows by the values of one or more columns or expressions. It is always used in conjunction with one or more aggregate functions.*/

drop table if exists Details1;

Create table Details1
    (id1 int,
     name2 nvarchar(50),
	 gender nvarchar(50),
	 salary int,
	 city1 nvarchar(50)
     )
INSERT INTO Details1 (id1,name2,gender,salary,city1 )
values
(1,'A','M',100,'LONDON'),(2,'B','F',500,'CANADA'),(3,'C','M',1000,'VRANDAVAN'),(4,'D','F',2000,'AYODHYA'),(5,'E','F',3000,'AYODHYA'),(6,'F','F',4000,'HIMALYA'),(7,'G','M',5000,'CANADA');

SELECT SUM(salary)  from Details1
--retrieving total salaries by city:We are applying SUM() aggregate function on Salary column, and grouping by city column. This effectively adds, all salaries of employees with in the same city.

Select city1, SUM(Salary) as TotalSalary 
from Details1 -- error 
Group by city1


Select city1,gender, SUM(Salary) as TotalSalary 
from Details1 -- error 
Group by city1,gender

--Query for retrieving total salaries and total number of employees by City, and by gender: The only difference here is that, we are using Count() aggregate function.

Select city1, gender, SUM(Salary) as TotalSalary,
COUNT(id1) as TotalEmployees
from Details1
group by city1, gender

--Filtering Groups: WHERE clause is used to filter rows before aggregation, where as HAVING clause is used to filter groups after aggregations. The following 2 queries produce the same result.

--Filtering rows using WHERE clause, before aggrgations take place:

Select city1, SUM(Salary) as TotalSalary
from Details1
Where city1 = 'canada'
group by city1

--Filtering groups using HAVING clause, after all aggrgations take place:
Select city1, SUM(Salary) as TotalSalary
from Details1
group by city1
Having city1 = 'canada'

/*From a performance standpoint, you cannot say that one method is less efficient than the other. Sql server optimizer analyzes each statement and selects an efficient way of executing it. As a best practice, use the syntax that clearly describes the desired result. Try to eliminate rows that you wouldn't need, as early as possible.

--It is also possible to combine WHERE and HAVING */

Select city1, gender, SUM(Salary) as TotalSalary
from details1
Where Gender = 'M'
group by city1,gender
Having city1 = 'canada'

Select city1, gender, SUM(Salary) as TotalSalary
from details1
Where Gender = 'M'and city1 = 'canada'
group by city1,gender


--Difference between WHERE and HAVING clause:

1. WHERE clause can be used with - Select, Insert, and Update statements, where as HAVING clause can only be used with the Select statement.
2. WHERE filters rows before aggregation (GROUPING), where as, HAVING filters groups, after the aggregations are performed.
3. Aggregate functions cannot be used in the WHERE clause, unless it is in a sub query contained in a HAVING clause, whereas, aggregate functions can be used in Having clause.
