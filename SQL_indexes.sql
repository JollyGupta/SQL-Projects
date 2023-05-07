use SQLPRACTICE

drop table if exists tblEmployee13;
Create table tblEmployee13
(
     Id int primary key,
     [Name] nvarchar(50),
     salary int,
	 Gender nvarchar(50)
)
Go
Create table tblEmployee13
(
     Id int,
     [Name] nvarchar(50),
     salary int,
	 Gender nvarchar(50)
)
Go
Insert into tblEmployee13 values (1, 'Sam', 2500,'M')
Insert into tblEmployee13 values (2, 'pam', 6500,'F')
Insert into tblEmployee13 values (3, 'john', 4500,'M')
Insert into tblEmployee13 values (4, 'sara', 5500,'F')
Insert into tblEmployee13 values (5, 'todd', 3100,'M')

--Consider, the following query
Select * from tblEmployee13 where Salary > 5000 and Salary < 7000

--To find all the employees, who has salary greater than 5000 and less than 7000, the query engine has to check each and every row in the table, resulting in a table scan, which can adversely affect the performance, especially if the table is large. Since there is no index, to help the query, the query engine performs an entire table scan.

/*Now Let's Create the Index to help the query:Here, we are creating an index on Salary column in the employee table*/

CREATE Index IX_tblEmployee_Salary 
ON tblEmployee13 ( salary ASC)

--To view the Indexes: In the object explorer, expand Indexes folder. Alternatively use sp_helptext wrong written system stored procedure. The following command query returns all the indexes on tblEmployee table.

Execute sp_help tblEmployee13
Execute sp_helpindex tblEmployee13

--To delete or drop the index: When dropping an index, specify the table name as well
Drop Index tblEmployee.IX_tblEmployee_Salary


--Clustered Index:
--A clustered index determines the physical order of data in a table. For this reason, a table can have only one clustered index. 

drop table if exists tblEmployee14;
CREATE TABLE tblEmployee14
(
 Id int Primary Key,
 Name1 nvarchar(50),
 Salary int,
 Gender nvarchar(10),
 City nvarchar(50)
)
--Note that Id column is marked as primary key. Primary key, constraint create clustered indexes automatically if no clustered index already exists on the table and a nonclustered index is not specified when you create the PRIMARY KEY constraint. 

--To confirm this, execute sp_helpindex tblEmployee, which will show a unique clustered index created on the Id column. 

--Now execute the following insert queries. Note that, the values for Id column are not in a sequential order.

Insert into tblEmployee14 Values(3,'John',4500,'Male','New York')
Insert into tblEmployee14 Values(1,'Sam',2500,'Male','London')
Insert into tblEmployee14 Values(4,'Sara',5500,'Female','Tokyo')
Insert into tblEmployee14 Values(5,'Todd',3100,'Male','Toronto')
Insert into tblEmployee14 Values(2,'Pam',6500,'Female','Sydney')

--Execute the following SELECT query
Select * from tblEmployee14

--Inspite, of inserting the rows in a random order, when we execute the select query we can see that all the rows in the table are arranged in an ascending order based on the Id column. This is because a clustered index determines the physical order of data in a table, and we have got a clustered index on the Id column.

--Because of the fact that, a clustered index dictates the physical storage order of the data in a table, a table can contain only one clustered index. If you take the example of tblEmployee table, the data is already arranged by the Id column, and if we try to create another clustered index on the Name column, the data needs to be rearranged based on the NAME column, which will affect the ordering of rows that's already done based on the ID column.

--For this reason, SQL server doesn't allow us to create more than one clustered index per table. The following SQL script, raises an error stating 'Cannot create more than one clustered index on table 'tblEmployee14'. Drop the existing clustered index PK__tblEmplo__3214EC0706CD04F7 before creating another.'

Create Clustered Index IX_tblEmployee_Name
ON tblEmployee14 (Name1)

--Cannot create more than one clustered index on table 'tblEmployee14'. Drop the existing clustered index 'PK__tblEmplo__3214EC0748958AAC' means primary key

--A clustered index is analogous to a telephone directory, where the data is arranged by the last name. We just learnt that, a table can have only one clustered index. However, the index can contain multiple columns (a composite index), like the way a telephone directory is organized by last name and first name.

--Let's now create a clustered index on 2 columns. To do this we first have to drop the existing clustered index on the Id column. 

Drop index tblEmployee14.PK__tblEmplo__3214EC0748958AAC
--not able to delete

--When you execute this query, you get an error message stating 'An explicit DROP INDEX is not allowed on index 'tblEmployee.PK__tblEmplo__3214EC070A9D95DB'. It is being used for PRIMARY KEY constraint enforcement.' We will talk about the role of unique index in the next session. To successfully delete the clustered index, right click on the index in the Object explorer window and select DELETE.

--Now, execute the following CREATE INDEX query, to create a composite clustered Index on the Gender and Salary columns.

-- first i have deleted index from object explorer under tblEmployee14

Create Clustered Index IX_tblEmployee_Gender_Salary
ON tblEmployee14(Gender ASC, Salary ASC)-- first sort by gender then within group salary wise
Select * from tblEmployee14

--Non Clustered Index:
--A nonclustered index is analogous to an index in a textbook. The data is stored in one place, the index in another place. The index will have pointers to the storage location of the data. Since, the nonclustered index is stored separately from the actual data, a table can have more than one non clustered index, just like how a book can have an index by Chapters at the beginning and another index by common terms at the end.

--In the index itself, the data is stored in an ascending or descending order of the index key, which doesn't in any way influence the storage of data in the table. 

--The following SQL creates a Nonclustered index on the NAME column on tblEmployee table:

Create NonClustered Index IX_tblEmployee_Name
ON tblEmployee14 (Name1)

--Unique index is used to enforce uniqueness of key values in the index. Let's understand this with an example.

drop table if exists tblEmployee15;
CREATE TABLE tblEmployee15
(
 [Id] int Primary Key,
 [FirstName] nvarchar(50),
 [LastName] nvarchar(50),
 [Salary] int,
 [Gender] nvarchar(10),
 [City] nvarchar(50)
)

--Since, we have marked Id column, as the Primary key for this table, a UNIQUE CLUSTERED INDEX gets created on the Id column, with Id as the index key. 

--We can verify this by executing the sp_helpindex system stored procedure as shown below.

Execute sp_helpindex tblEmployee15

--Since, we now have a UNIQUE CLUSTERED INDEX on the Id column, any attempt to duplicate the key values, will throw an error stating 'Violation of PRIMARY KEY constraint 'PK__tblEmplo__3214EC07236943A5'. Cannot insert duplicate key in object dbo.tblEmployee15'

--Example: The following insert queries will fail- id is same 1,1

Insert into tblEmployee15 Values(1,'Mike', 'Sandoz',4500,'Male','New York')
Insert into tblEmployee15 Values(1,'John', 'Menco',2500,'Male','London')

--Now let's try to drop the Unique Clustered index on the Id column. This will raise an error stating - 'An explicit DROP INDEX is not allowed on index tblEmployee.PK__tblEmplo__3214EC07236943A5. It is being used for PRIMARY KEY constraint enforcement.' (* but using object explorer we can delete this)

Drop index tblEmployee.PK__tblEmplo__3214EC073B741309

--So this error message proves that, SQL server internally, uses the UNIQUE index to enforce the uniqueness of values and primary key.

--Expand keys folder in the object explorer window, and you can see a primary key constraint. Now, expand the indexes folder and you should see a unique clustered index. In the object explorer it just shows the 'CLUSTERED' word. To, confirm, this is infact an UNIQUE index, right click and select properties. The properties window, shows the UNIQUE checkbox being selected.

--SQL Server allows us to delete this UNIQUE CLUSTERED INDEX from the object explorer. so, Right click on the index, and select DELETE and finally, click OK. Along with the UNIQUE index, the primary key constraint is also deleted.

--Now, let's try to insert duplicate values for the ID column. The rows should be accepted, without any primary key violation error.

Execute sp_helpindex tblEmployee15
Insert into tblEmployee15 Values(1,'Mike', 'Sandoz',4500,'Male','New York')
Insert into tblEmployee15 Values(1,'John', 'Menco',2500,'Male','London')
Select * from tblEmployee15

--So, the UNIQUE index is used to enforce the uniqueness of values and primary key constraint.

--UNIQUENESS is a property of an Index, and both CLUSTERED and NON-CLUSTERED indexes can be UNIQUE.

--Creating a UNIQUE NON CLUSTERED index on the FirstName and LastName columns.

Create Unique NonClustered Index UIX_tblEmployee_FirstName_LastName
On tblEmployee15(FirstName, LastName)

--This unique non clustered index, ensures that no 2 entires in the index has the same first and last names. a Unique Constraint, can be used to enforce the uniqueness of values, across one or more columns. There are no major differences between a unique constraint and a unique index. 

--In fact, when you add a unique constraint, a unique index gets created behind the scenes. To prove this, let's add a unique constraint on the city column of the tblEmployee table. (2ndway to make unique non clustered)

ALTER TABLE tblEmployee15
ADD CONSTRAINT UQ_tblEmployee_City 
UNIQUE NONCLUSTERED (City)

--At this point, we expect a unique constraint to be created. Refresh and Expand the constraints folder in the object explorer window. The constraint is not present in this folder. Now, refresh and expand the 'indexes' folder. In the indexes folder, you will see a UNIQUE NONCLUSTERED index with name UQ_tblEmployee_City.

--Also, executing lists the constraint as a UNIQUE NONCLUSTERED index.

EXECUTE SP_HELPCONSTRAINT tblEmployee15

--So creating a UNIQUE constraint, actually creates a UNIQUE index. So a UNIQUE index can be created explicitly, using CREATE INDEX statement or indirectly using a UNIQUE constraint. So, when should you be creating a Unique constraint over a unique index.To make our intentions clear, create a unique constraint, when data integrity is the objective. This makes the objective of the index very clear. In either cases, data is validated in the same manner, and the query optimizer does not differentiate between a unique index created by a unique constraint or manually created.
/*
Note:
1. By default, a PRIMARY KEY constraint, creates a unique clustered index, where as a UNIQUE constraint creates a unique nonclustered index. These defaults can be changed if you wish to.

2. A UNIQUE constraint or a UNIQUE index cannot be created on an existing table, if the table contains duplicate values in the key columns. Obviously, to solve this,remove the key columns from the index definition or delete or update the duplicate values.

3. By default, duplicate values are not allowed on key columns, when you have a unique index or constraint. For, example, if I try to insert 10 rows, out of which 5 rows contain duplicates, then all the 10 rows are rejected. However, if I want only the 5 duplicate rows to be rejected and accept the non-duplicate 5 rows, then I can use IGNORE_DUP_KEY option. An example of using IGNORE_DUP_KEY option is shown below.*/

--The IGNORE_DUP_KEY index option can be specified for both clustered and nonclustered unique indexes. Using it on a clustered index can result in much poorer performance than for a nonclustered unique index
drop table if exists tblEmployee15;
CREATE TABLE tblEmployee15
(
 [Id] int Primary Key,
 [FirstName] nvarchar(50),
 [LastName] nvarchar(50),
 [Salary] int,
 [Gender] nvarchar(10),
 [City] nvarchar(50)
)

Insert into tblEmployee15 Values(1,'Mike', 'Sandoz',4500,'Male','New York')
Insert into tblEmployee15 Values(2,'John', 'Menco1',2500,'Female','London')
Insert into tblEmployee15 Values(3,'John', 'Menco1',2500,'Female','London1')
Insert into tblEmployee15 Values(4,'John', 'Menco3',4500,'Female','London2')
Insert into tblEmployee15 Values(5,'John', 'Menco4',5500,'Male','London3')

Select * from tblEmployee15

EXECUTE SP_HELPCONSTRAINT tblEmployee15
EXECUTE SP_HELPindex tblEmployee15

CREATE UNIQUE INDEX IX_tblEmployee_City
ON tblEmployee15(City)

WITH IGNORE_DUP_KEY -- not able to use this ????????????????
Select * from tblEmployee15


 --Indexes are used by queries to find data quickly. In this part, we will learn about the different queries that can benefit from indexes.
drop table if exists tblEmployee16;
CREATE TABLE tblEmployee16
(
 [Id] int Primary Key,
 [FirstName] nvarchar(50),
 [LastName] nvarchar(50),
 [Salary1] int,
 [Gender] nvarchar(10),
 [City] nvarchar(50)
)


Insert into tblEmployee16 Values(1,'Mike', 'Sandoz',4500,'Male','New York')
Insert into tblEmployee16 Values(2,'Sara', 'Menco',6500,'Female','London')
Insert into tblEmployee16 Values(3,'John', 'Barber',2500,'Male','Sydney')
Insert into tblEmployee16 Values(4,'Pam', 'Grove',3500,'Female','Toronto')
Insert into tblEmployee16 Values(5,'James', 'Mirch',7500,'Male','London')

--Create a Non-Clustered Index on Salary Column
Create NonClustered Index IX_tblEmployee_Salary1
On tblEmployee16 (Salary1 Asc)
Select * from tblEmployee16

--the following select query benefits from the index on the Salary column, because the salaries are sorted in ascending order in the index. From the index, it's easy to identify the records where salary is between 4000 and 8000, and using the row address the corresponding records from the table can be fetched quickly.

Select * from tblEmployee16 where Salary1 > 4000 and Salary1 < 8000

--Not only, the SELECT statement, even the following DELETE and UPDATE statements can also benefit from the index. To update or delete a row, SQL server needs to first find that row, and the index can help in searching and finding that specific row quickly.

Delete from tblEmployee16 where Salary1 = 2500
Update tblEmployee16 Set Salary1 = 9000 where Salary1 = 7500

--Indexes can also help queries, that ask for sorted results. Since the Salaries are already sorted, the database engine, simply scans the index from the first entry to the last entry and retrieve the rows in sorted order. This avoids, sorting of rows during query execution, which can significantly imrpove the processing time.

Select * from tblEmployee16 order by Salary1

--The index on the Salary column, can also help the query below, by scanning the index in reverse order.
Select * from tblEmployee16 order by Salary1 Desc

--GROUP BY queries can also benefit from indexes. To group the Employees with the same salary, the query engine, can use the index on Salary column, to retrieve the already sorted salaries. Since matching salaries are present in consecutive index entries, it is to count the total number of Employees  at each Salary quickly. 

Select Salary1, COUNT(Salary1) as Total
from tblEmployee16
Group By Salary1
