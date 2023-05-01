/*To create the database graphically
1. Right Click on Databases folder in the Object explorer
2. Select New Database
3. In the New Database dialog box, enter the Database name and click OK.*/

--To Create the database using a query
Create database SQLPRACTICEJOLLY

---To alter a database, once it's created 

Alter database SQLPRACTICE Modify Name = SQLPRACTICAL 

--Alternatively, you can also use system stored procedure
--Execute sp_renameDB 'OldDatabaseName','NewDatabaseName'

Execute sp_renameDB 'SQLPRACTICAL','SQLPRACTICE'


--To Delete or Drop a database
Drop Database SQLPRACTICE

-- refresh by clicking main database
Create database SQLPRACTICE

/*You cannot drop a database, if it is currently in use. You get an error stating - Cannot drop database "NewDatabaseName" because it is currently in use. So, if other users are connected, you need to put the database in single user mode and then drop the database.*/
Alter Database DatabaseName Set SINGLE_USER With Rollback Immediate

--With Rollback Immediate option, will rollback all incomplete transactions and closes the connection to the database.

--Creating and Working with tables 

/*Use SQLPRACTICE -done 
To create tblPerson table, graphically, using SQL Server Management Studio
1. Right click on Tables folder in Object explorer window
2. Select New Table
3. Fill Column Name, Data Type and Allow Nulls, as shown below and save the table as tblPerson.*/

--The primary key is used to uniquely identify each row in a table. Primary key does not allow nulls.

drop table if exists tblPersonQuery;
drop table if exists tblGenderQuery;

Create Table tblPersonQuery
(ID int,
Name1 varchar(50),
Email varchar(50),
GenderID int )

Create Table tblGenderQuery
(ID int Not Null Primary Key,
Gender nvarchar(50))


--In tblPerson table, GenderID is the foreign key referencing ID column in tblGender table. Foreign key references can be added graphically using SSMS or using a query.

--To add a foreign key reference using a query
--ALTER TABLE Table_Name1 ADD CONSTRAINT ForeignKey_Name FOREIGN KEY (Column_Name) REFERENCES Table_Name2 (Column_Name);  

Alter table tblPersonQuery
ADD CONSTRAINT tblPersonQuery_GenderId_FK FOREIGN KEY (GenderID) references tblGenderQuery(ID)

ALTER TABLE tblPersonQuery
DROP CONSTRAINT IF EXISTS tblPersonQuery_GenderId_FK;

--DROP CONSTRAINT tblPersonQuery_GenderId_FK
--DROP FOREIGN KEY FK_PersonOrder;

--The general formula is here
--Alter table ForeignKeyTable add constraint ForeignKeyTable_ForiegnKeyColumn_FK 
--FOREIGN KEY (ForiegnKeyColumn) references PrimaryKeyTable (PrimaryKeyColumn)

/*Foreign keys are used to enforce database integrity. In layman's terms, A foreign key in one table points to a primary key in another table. The foreign key constraint prevents invalid data form being inserted into the foreign key column. The values that you enter into the foreign key column, has to be one of the values contained in the table it points to.*/

Select * from tblPersonQuery
Select * from tblGenderQuery


INSERT INTO tblGenderQuery (ID ,Gender )
values
(1, 'Male'),(2, 'Female'),
(3, 'unknown');

INSERT INTO tblPersonQuery (ID ,Name1 ,Email,GenderID )
values(1, 'ram', 'ram@gmail.com',2),(2, 'sita', 'sita@gmail.com',2),
(3, 'Hanuman', 'hanuman@gmail.com',1),(4,'Ha', 'ha@gmail.com',1),(5, 'Han', 'han@gmail.com',3);

 --A column default can be specified using Default constraint. The default constraint is used to insert a default value into a column. The default value will be added to all new records, if no other value is specified, including NULL.

--Altering an existing column to add a default constraint:

/*ALTER TABLE tblPersonGraph
ADD CONSTRAINT { CONSTRAINT_NAME }
DEFAULT { DEFAULT_VALUE } FOR { EXISTING_COLUMN_NAME }*/

INSERT INTO tblPersonQuery(ID ,Name1 ,Email)
values (4, 'john', 'john@gmail.com');

select * from tblPersonQuery

-- in case of no supply of any genderID , this column will take 5 by default

ALTER TABLE tblPersonQuery
ADD CONSTRAINT DF_tblPerson_GenderID
DEFAULT 5 FOR GenderID;

select * from tblPersonQuery
-------------------------------------------------------------
ALTER TABLE tblPersonQuery
DROP CONSTRAINT IF EXISTS DF_tblPerson_GenderID;

ALTER TABLE tblPersonQuery
ADD CONSTRAINT DF_tblPerson_GenderID
DEFAULT 5 FOR GenderID;

select * from tblPersonQuery

/*Adding a new column, with default value, to an existing table:
ALTER TABLE { TABLE_NAME } 
ADD { COLUMN_NAME } { DATA_TYPE } { NULL | NOT NULL } 
CONSTRAINT { CONSTRAINT_NAME } DEFAULT { DEFAULT_VALUE }*/

--On the other hand, the following insert statement will insert NULL, instead of using the default.
--Insert into tblPerson(ID,Name,Email,GenderId) values (6,'Dan','d@d.com',NULL)


--To drop a constraint
ALTER TABLE  tblPersonQuery
DROP CONSTRAINT DF_tblPerson_GenderID

--Cascading referential integrity constraint
--Cascading referential integrity constraint can be used to define actions Microsoft SQL Server should take when this happens. By default, we get an error and the DELETE or UPDATE statement is rolled back.

/*
However, you have the following options when setting up Cascading referential integrity constraint
1. No Action: This is the default behaviour. No Action specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, an error is raised and the DELETE or UPDATE is rolled back.


2. Cascade: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are also deleted or updated.


3. Set NULL: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are set to NULL.  


4. Set Default: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are set to default values.*/

-- click on keys in tblpersonquery, modify-insert/update, action 2,3,4, 


Select * from tblPersonQuery
Select * from tblGenderQuery

delete from tblGenderQuery where ID=2 

/*an error should be raised yes*/
--The DELETE statement conflicted with the REFERENCE constraint "tblPersonQuery_GenderId_FK". The conflict occurred in database "SQLPRACTICE", table "dbo.tblPersonQuery", column 'GenderID'.


-- click on keys in tblpersonquery, modify-insert/update, action - set default, 
Select * from tblPersonQuery
Select * from tblGenderQuery

delete from tblGenderQuery where ID=2 --error it should be 5 , instead of 2

-- action - null Set NULL: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are set to NULL.

Select * from tblPersonQuery
Select * from tblGenderQuery
delete from tblGenderQuery where ID=2 -- working fine

--Cascade: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are also deleted or updated.

Select * from tblPersonQuery
Select * from tblGenderQuery
delete from tblGenderQuery where ID = 3 -- han should be deleted but null comes why?
-------------------------------------------------------------------
--CHECK constraint is used to limit the range of the values, that can be entered for a column.

drop table if exists tblPersonQuery1;
drop table if exists tblGenderQuery1;

--using SQL query check constraints

Create Table tblPersonQuery1
(ID1 int,
Name2 varchar(50),
Email1 varchar(50),
GenderID1 int,
Age int)
--Age int CHECK(Age>50)) -- error occour bcoz in insert - age is <50

Create Table tblGenderQuery1
(ID1 int Not Null Primary Key,
Gender1 nvarchar(50))

INSERT INTO tblGenderQuery1 (ID1 ,Gender1 )
values
(1, 'Male'),(2, 'Female'),
(3, 'unknown');

INSERT INTO tblPersonQuery1 (ID1 ,Name2 ,Email1,GenderID1,Age )
values(1, 'a', 'ram@gmail.com',2,12),
(2, 'b', 'sita@gmail.com',1,20),
(3, 'c', 'hanuman@gmail.com',3,30),
(4,'d', 'ha@gmail.com',4,40),
(5, 'e', 'han@gmail.com',2, 101)

Select * from tblPersonQuery1
Select * from tblGenderQuery1
-------------------------------
---Table Level constraint 
Alter table tblPersonQuery1
--Add constraint Age Check(Age>10)--no error
Add constraint Age1 Check(Age1>30)--error

Select * from tblPersonQuery1
Select * from tblGenderQuery1

--The ALTER TABLE statement is used to add, delete, or modify columns in an existing table.

Alter table tblPersonQuery1
ADD CONSTRAINT tblPersonQuery1_GenderId_FK FOREIGN KEY (GenderID1) references tblGenderQuery1(ID1)

DROP constraint IF EXISTS tblPersonQuery2_GenderId_FK;

--Let's say, we have an integer AGE column, in a table. The AGE in general cannot be less than ZERO and at the same time cannot be greater than 150. But, since AGE is an integer column it can accept negative values and values much greater than 150.
--So, to limit the values, that can be added, we can use CHECK constraint. In SQL Server, CHECK constraint can be created graphically, or using a query.


--doubt: difficulty in adding foreign key, sometimes its reflected somtimes not 

drop table if exists tblPersonQuery1;
drop table if exists tblGenderQuery1;

Create Table tblGenderQuery1
(ID1 int Not Null Primary Key,
Gender1 nvarchar(50))

Create Table tblPersonQuery1
(ID1 int,
Name2 varchar(50),
Email1 varchar(50),
GenderID1 int Constraint FK_tblPersonQuery1 References tblGenderQuery1(ID1),
Age int)
--Age int CHECK(Age>50)) -- error occour bcoz in insert - age is <50



INSERT INTO tblGenderQuery1 (ID1 ,Gender1 )
values
(1, 'Male'),(2, 'Female'),
(3, 'unknown');

INSERT INTO tblPersonQuery1 (ID1 ,Name2 ,Email1,GenderID1,Age )
values(1, 'a', 'ram@gmail.com',2,12),
(2, 'b', 'sita@gmail.com',1,20),
(3, 'c', 'hanuman@gmail.com',3,30),
(4,'d', 'ha@gmail.com',4,40),
(5, 'e', 'han@gmail.com',2, 101);

Select * from tblPersonQuery1
Select * from tblGenderQuery1
--The INSERT statement conflicted with the FOREIGN KEY constraint "FK_tblPersonQuery1". The conflict occurred in database "SQLPRACTICE", table "dbo.tblGenderQuery1", column 'ID1'.

--getting error but foreign key is created

/*The general formula for adding check constraint in SQL Server:
ALTER TABLE { TABLE_NAME }
ADD CONSTRAINT { CONSTRAINT_NAME } CHECK ( BOOLEAN_EXPRESSION )*/

--The following check constraint, limits the age between ZERO and 150.
INSERT INTO tblPersonQuery1 values(3, 'a', 'ram@gmail.com',2,10)

ALTER TABLE tblPersonQuery1
ADD CONSTRAINT CK_tblPerson_Age CHECK (Age > 0 AND Age < 150)

--If the BOOLEAN_EXPRESSION returns true, then the CHECK constraint allows the value, otherwise it doesn't. Since, AGE is a nullable column, it's possible to pass null for this column, when inserting a row. When you pass NULL for the AGE column, the boolean expression evaluates to UNKNOWN, and allows the value.


--To drop the CHECK constraint:
ALTER TABLE tblPersonQuey1
DROP CONSTRAINT CK_tblPerson_Age

--Unique key constraint We use UNIQUE constraint to enforce uniqueness of a column i.e the column shouldn't allow any duplicate values. We can add a Unique constraint thru the designer or using a query.

--To create the unique key using a query:

Alter Table Table_Name
Add Constraint Constraint_Name Unique(Column_Name)

drop table if exists tblPersonQuery1;
drop table if exists tblGenderQuery1;

--using SQL query check constraints

Create Table tblPersonQuery1
(ID1 int,
Name2 varchar(50),
Email1 varchar(50),
GenderID1 int,
Age int)
--Age int CHECK(Age>50)) -- error occour bcoz in insert - age is <50

Create Table tblGenderQuery1
(ID1 int Not Null Primary Key,
Gender1 nvarchar(50))



INSERT INTO tblGenderQuery1 (ID1 ,Gender1 )
values
(1, 'Male'),(2, 'Female'),
(3, 'unknown');

INSERT INTO tblPersonQuery1 values(1, 'a', 'ram@gmail.com',2,12)
INSERT INTO tblPersonQuery1 values(2, 'b', 'ram@gmail.com',3,16)

--To create the unique key using a query:

Alter Table tblGenderQuery1
Add Constraint UQ_tblGenderQuery1_Email1 Unique (Email1)

Alter Table tblGenderQuery1
DROP Constraint IF EXISTS UQ_tblGenderQuery1_Email1

select * from tblPersonQuery1
---------------------------------------
drop table if exists tblPersonQuery1;
drop table if exists tblGenderQuery1;

CREATE TABLE tblPersonQuery1 (
  ID1 INT,
  Name2 VARCHAR(50),
  --Email1 VARCHAR(50),
  Email1 VARCHAR(50),
  GenderID1 INT,
  Age INT CHECK(Age > 50)
);

CREATE TABLE tblGenderQuery1 (
  ID1 INT NOT NULL PRIMARY KEY,
  Gender1 NVARCHAR(50)
);

INSERT INTO tblGenderQuery1 (ID1, Gender1)
VALUES (1, 'Male'), (2, 'Female'), (3, 'Unknown');

INSERT INTO tblPersonQuery1 (ID1, Name2, Email1, GenderID1, Age)
VALUES (1, 'a', 'ram@gmail.com', 2, 55),
       (2, 'b', 'ra@gmail.com', 3, 60);

ALTER TABLE tblPersonQuery1 
ADD CONSTRAINT UQ_tblGenderQuery1_Email1 UNIQUE (Email1);
--ADD UNIQUE (Email1);

https://www.youtube.com/watch?v=cKNQRAMoQHw

--error when duplicate email id The CREATE UNIQUE INDEX statement terminated because a duplicate key was found for the object name 'dbo.tblPersonQuery1'

--no error if no duplicate