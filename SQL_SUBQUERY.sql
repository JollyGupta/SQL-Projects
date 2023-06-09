--Subquery
drop table if exists tblProducts
Create Table tblProducts
(
 [Id] int identity primary key,
 [Name] nvarchar(50),
 [Description] nvarchar(250)
)

drop table if exists tblProductSales1
Create Table tblProductSales1
(
 Id int primary key identity,
 ProductId int foreign key references tblProducts(Id),
 UnitPrice int,
 QuantitySold int
)


Insert into tblProducts values ('TV', '52 inch black color LCD TV')
Insert into tblProducts values ('Laptop', 'Very thin black color acer laptop')
Insert into tblProducts values ('Desktop', 'HP high performance desktop')

Insert into tblProductSales1 values(3, 450, 5)
Insert into tblProductSales1 values(2, 250, 7)
Insert into tblProductSales1 values(3, 450, 4)
Insert into tblProductSales1 values(3, 450, 9)

--Write a query to retrieve products that are not at all sold?

Select [Id], [Name], [Description]
from tblProducts
where Id not in (Select Distinct ProductId from tblProductSales1)

--Most of the times subqueries can be very easily replaced with joins. The above query is rewritten using joins and produces the same results. 

Select tblProducts.[Id], [Name], [Description]
from tblProducts
left join tblProductSales1
on tblProducts.Id = tblProductSales1.ProductId
where tblProductSales1.ProductId IS NULL

--Let us now discuss about using a sub query in the SELECT clause. Write a query to retrieve the NAME and TOTALQUANTITY sold, using a subquery.
Select [Name],
(Select SUM(QuantitySold) from tblProductSales1 where ProductId = tblProducts.Id) as TotalQuantity
from tblProducts
order by Name

--Query with an equivalent join that produces the same result.

Select [Name], SUM(QuantitySold) as TotalQuantity
from tblProducts
left join tblProductSales1
on tblProducts.Id = tblProductSales1.ProductId
group by [Name]
--order by Name

--From these examples, it should be very clear that, a subquery is simply a select statement, that returns a single value and can be nested inside a SELECT, UPDATE, INSERT, or DELETE statement. 
--It is also possible to nest a subquery inside another subquery.
--According to MSDN, subqueries can be nested upto 32 levels.

--Subqueries are always encolsed in paranthesis and are also called as inner queries, and the query containing the subquery is called as outer query.

The columns from a table that is present only inside a subquery, cannot be used in the SELECT list of the outer query.

--Correlated subquery

--sub query is executed first and only once. The sub query results are then used by the outer query. A non-corelated subquery can be executed independently of the outer query.

Select [Id], [Name], [Description]
from tblProducts
where Id not in (Select Distinct ProductId from tblProductSales1)

--If the subquery depends on the outer query for its values, then that sub query is called as a correlated subquery. In the where clause of the subquery below, "ProductId" column get it's value from tblProducts table that is present in the outer query. So, here the subquery is dependent on the outer query for it's value, hence this subquery is a correlated subquery. Correlated subqueries get executed, once for every row that is selected by the outer query. Corelated subquery, cannot be executed independently of the outer query.

Select [Name],
(Select SUM(QuantitySold) from tblProductSales1 where ProductId = tblProducts.Id) as TotalQuantity
from tblProducts
order by Name

--error The multi-part identifier "tblProducts.Id" could not be bound if we execute only Select SUM(QuantitySold) from tblProductSales1 where ProductId = tblProducts.Id) as TotalQuantity

------Creating a large table with random data for performance testing -
--If Table exists drop the tables
If (Exists (select * 
            from information_schema.tables 
            where table_name = 'tblProductSales1'))
Begin
 Drop Table tblProductSales1
End

If (Exists (select * 
            from information_schema.tables 
            where table_name = 'tblProducts'))
Begin
 Drop Table tblProducts
End



-- Recreate tables
Create Table tblProducts
(
 [Id] int identity primary key,
 [Name] nvarchar(50),
 [Description] nvarchar(250)
)

Create Table tblProductSales1
(
 Id int primary key identity,
 ProductId int foreign key references tblProducts(Id),
 UnitPrice int,
 QuantitySold int
)

--Insert Sample data into tblProducts table
Declare @Id int
Set @Id = 1

While(@Id <= 300000)
Begin
 Insert into tblProducts values('Product - ' + CAST(@Id as nvarchar(20)), 
 'Product - ' + CAST(@Id as nvarchar(20)) + ' Description')
 
 Print @Id
 Set @Id = @Id + 1
End

--Select * from tblProducts
--Select * from tblProductSales1

-- Declare variables to hold a random ProductId, 
-- UnitPrice and QuantitySold
declare @RandomProductId int
declare @RandomUnitPrice int
declare @RandomQuantitySold int

-- Declare and set variables to generate a 
-- random ProductId between 1 and 100000
declare @UpperLimitForProductId int
declare @LowerLimitForProductId int

set @LowerLimitForProductId = 1
set @UpperLimitForProductId = 100000

-- Declare and set variables to generate a 
-- random UnitPrice between 1 and 100
declare @UpperLimitForUnitPrice int
declare @LowerLimitForUnitPrice int

set @LowerLimitForUnitPrice = 1
set @UpperLimitForUnitPrice = 100

-- Declare and set variables to generate a 
-- random QuantitySold between 1 and 10
declare @UpperLimitForQuantitySold int
declare @LowerLimitForQuantitySold int

set @LowerLimitForQuantitySold = 1
set @UpperLimitForQuantitySold = 10

--Insert Sample data into tblProductSales table
Declare @Counter int
Set @Counter = 1

While(@Counter <= 450000)
Begin
 select @RandomProductId = Round(((@UpperLimitForProductId - @LowerLimitForProductId) * Rand() + @LowerLimitForProductId), 0)
 select @RandomUnitPrice = Round(((@UpperLimitForUnitPrice - @LowerLimitForUnitPrice) * Rand() + @LowerLimitForUnitPrice), 0)
 select @RandomQuantitySold = Round(((@UpperLimitForQuantitySold - @LowerLimitForQuantitySold) * Rand() + @LowerLimitForQuantitySold), 0)
 
 Insert into tblProductsales1 
 values(@RandomProductId, @RandomUnitPrice, @RandomQuantitySold)

 Print @Counter
 Set @Counter = @Counter + 1
End

--Finally, check the data in the tables using a simple SELECT query to make sure the data has been inserted as expected.

Select * from tblProducts
Select * from tblProductSales1

--What to choose for performance - SubQueries or Joins 
According to MSDN, in sql server, in most cases, there is usually no performance difference between queries that uses sub-queries and equivalent queries using joins. For example, on my machine I have
400,000 records in tblProducts table
600,000 records in tblProductSales tables


--The following query, returns, the list of products that we have sold atleast once. This query is formed using sub-queries. When I execute this query I get 306,199 rows in 6 seconds (2-3 seconds on SQL 22,9883 rows)
Select Id, Name, Description
from tblProducts
where ID IN
(
 Select ProductId from tblProductSales1
)


--At this stage please clean the query and execution plan cache using the following T-SQL command.

CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; -- Clears query cache
Go
DBCC FREEPROCCACHE; -- Clears execution plan cache
GO

--Now, run the query that is formed using joins. Notice that I get the exact same 306,199 rows in 6 seconds. 

Select distinct tblProducts.Id, Name, Description
from tblProducts
inner join tblProductSales1
on tblProducts.Id = tblProductSales1.ProductId

--Please Note: I have used automated sql script to insert huge amounts of this random data.

--According to MSDN, in some cases where existence must be checked, a join produces better performance. Otherwise, the nested query must be processed for each result of the outer query. In such cases, a join approach would yield better results.

--The following query returns the products that we have not sold at least once. This query is formed using sub-queries. When I execute this query I get 93,801 rows in 3 seconds...(303508 rows , 5 seconds)

Select Id, Name, [Description]
from tblProducts
where Not Exists(Select * from tblProductSales1 where ProductId = tblProducts.Id)

--When I execute the below equivalent query, that uses joins, I get the exact same 93,801 rows in 3 seconds. (303508 rows , 5 seconds)

Select tblProducts.Id, Name, [Description]
from tblProducts
left join tblProductSales1
on tblProducts.Id = tblProductSales1.ProductId
where tblProductSales1.ProductId IS NULL 

--In general joins work faster than sub-queries, but in reality it all depends on the execution plan that is generated by SQL Server. It does not matter how we have written the query, SQL Server will always transform it on an execution plan. If sql server generates the same plan from both queries, we will get the same result.

I would say, rather than going by theory, turn on client statistics and execution plan to see the performance of each option, and then make a decision.
