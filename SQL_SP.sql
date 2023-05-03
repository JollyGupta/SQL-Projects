/*A stored procedure is group of T-SQL (Transact SQL) statements. If you have a situation, where you write the same query over and over again, you can save that specific query as a stored procedure and call it just by it's name.

how to create, execute, change and delete stored procedures. */

use SQLPRACTICE
drop table if exists tblEmployee4;

--SQL Script to create tblEmployee and tblDepartment tables

Create table tblEmployee4
(
     Id int primary key,
     Name1 nvarchar(50),
     gender nvarchar(50),
	 departmentid int
)
Go

Insert into tblEmployee4 values (1, 'mike', 'M',1 )
Insert into tblEmployee4 values (2, 'hike', 'f',1 )
Insert into tblEmployee4 values (3, 'aike', 'M',3)
Insert into tblEmployee4 values (4, 'bike', 'f',2 )
Insert into tblEmployee4 values (5, 'cike', 'M',3 )
Insert into tblEmployee4 values (6, 'dike', 'f',2 )
Insert into tblEmployee4 values (7, 'eike', 'M',1 )
Insert into tblEmployee4 values (8, 'fike', 'f',2 )
Insert into tblEmployee4 values (9, 'gike', 'M',1 )
Insert into tblEmployee4 values (9, 'ike', 'f',2 )

--Creating a simple stored procedure without any parameters: This stored procedure, retrieves Name and Gender of all the employees. To create a stored procedure we use, CREATE PROCEDURE or CREATE PROC statement.

Create Procedure SptblEmployee4
as
Begin
  Select Name1, Gender from tblEmployee4
End

SptblEmployee4
EXEC SptblEmployee4
Execute SptblEmployee4

--Note: You can also right click on the procedure name, in object explorer in SQL Server Management Studio and select EXECUTE STORED PROCEDURE.

/*Creating a stored procedure with input parameters: This SP, accepts GENDER and DEPARTMENTID parameters. Parameters and variables have an @ prefix in their name.
To invoke this procedure, we need to pass the value for @Gender and @DepartmentId parameters. If you don't specify the name of the parameters, you have to first pass value for @Gender parameter and then for @DepartmentId.*/

-- 

Create Procedure SptblEmployee4ByGenderAndDepartment 
@Gender nvarchar(50),
@DepartmentId int
as
Begin
  Select Name1, gender from tblEmployee4 Where gender = @Gender and departmentId = @DepartmentId
End

SptblEmployee4ByGenderAndDepartment 'f', 2
EXECUTE SptblEmployee4ByGenderAndDepartment @DepartmentId=1, @Gender = 'M'

====
--To change the stored procedure, use ALTER PROCEDURE statement:
Alter Procedure SptblEmployee4ByGenderAndDepartment
@Gender nvarchar(50),
@DepartmentId int
as
Begin
  Select Name1, gender from tblEmployee4 Where gender = @Gender and departmentId = @DepartmentId order by Name1
End
EXECUTE SptblEmployee4ByGenderAndDepartment @DepartmentId=1, @Gender = 'M'

--To view the text, of the stored procedure
 sp_helptext 'SptblEmployee4ByGenderAndDepartment'

--Right Click the SP in Object explorer -> Scrip Procedure as -> Create To -> New Query Editor Window

--To encrypt the text of the SP, use WITH ENCRYPTION option. Once, encrypted, you cannot view the text of the procedure, using sp_helptext system stored procedure. There are ways to obtain the original text, which we will talk about in a later session.

Alter Procedure SptblEmployee4ByGenderAndDepartment
@Gender nvarchar(50),
@DepartmentId int
WITH ENCRYPTION
as
Begin
  Select Name1, gender from tblEmployee4 Where gender = @Gender and departmentId = @DepartmentId
End

 --sp_helptext 'SptblEmployee4ByGenderAndDepartment' The text for object 'SptblEmployee4ByGenderAndDepartment' is encrypted.

--To delete the SP, 
DROP PROC 'SptblEmployee4ByGenderAndDepartment' 
DROP PROCEDURE 'SptblEmployee4ByGenderAndDepartment'

--Stored procedures with output parameters
--we use the keywords OUT or OUTPUT. @EmployeeCount is an OUTPUT parameter. Notice, it is specified with OUTPUT keyword. 

Create Procedure spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int Output
as
Begin
 Select @EmployeeCount = COUNT(Id) 
 from tblEmployee4 
 where gender = @Gender
End

--To execute this stored procedure with OUTPUT parameter
/*
1. First initialise a variable of the same datatype as that of the output parameter. We have declared @EmployeeTotal integer variable. 
2. Then pass the @EmployeeTotal variable to the SP. You have to specify the OUTPUT keyword. If you don't specify the OUTPUT keyword, the variable will be NULL. 
3. Execute*/
-- M is 5, F is 4 because 9 id is same for 2 females

Declare @EmployeeTotal int
Execute spGetEmployeeCountByGender 'M', @EmployeeTotal out
Print @EmployeeTotal

--If you don't specify the OUTPUT keyword, when executing the stored procedure, the @EmployeeTotal variable will be NULL. Here, we have not specified OUTPUT keyword. When you execute, you will see '@EmployeeTotal is null' printed.

Declare @EmployeeTotal int
Execute spGetEmployeeCountByGender 'M', @EmployeeTotal
if(@EmployeeTotal is null)
 Print '@EmployeeTotal is null'
else
 Print '@EmployeeTotal is not null'
 -----------------------------------------
Declare @EmployeeTotal int 
Execute spGetEmployeeCountByGender 'M', @EmployeeTotal out
if(@EmployeeTotal is null)
 Print '@EmployeeTotal is null'
else
 Print '@EmployeeTotal is not null'
 -----------------------------------------------------
 --The following system stored procedures, are extremely useful when working procedures.
--sp_help SP_Name : View the information about the stored procedure, like parameter names, their datatypes etc. sp_help can be used with any database object, like tables, views, SP's, triggers etc. Alternatively, you can also press ALT+F1, when the name of the object is highlighted.

sp_help spGetEmployeeCountByGender

--sp_helptext SP_Name : View the Text of the stored procedure
sp_helptext spGetEmployeeCountByGender

--sp_depends SP_Name : View the dependencies of the stored procedure. This system SP is very useful, especially if you want to check, if there are any stored procedures that are referencing a table that you are abput to drop. 
sp_depends spGetEmployeeCountByGender

--sp_depends SP_Name can also be used with other database objects like table etc.
sp_depends spGetEmployeeCountByGender

--Note: All parameter and variable names in SQL server, need to have the @symbol.

sp_help tblEmployee4

--Stored procedure output parameters or return values
--The following procedure returns total number of employees in the Employees table, using output parameter - @TotalCount.

Create Procedure spGetTotalCountOfEmployees1
@TotalCount int output
as
Begin
 Select @TotalCount = COUNT(ID) from tblEmployee4
End

--Executing spGetTotalCountOfEmployees1 returns 9.
Declare @TotalEmployees int
Execute spGetTotalCountOfEmployees1 @TotalEmployees Output
Select @TotalEmployees

--Re-written stored procedure using return variables
Create Procedure spGetTotalCountOfEmployees2
as
Begin
 return (Select COUNT(ID) from tblEmployee4)
End

--Executing spGetTotalCountOfEmployees2 returns 9.

Declare @TotalEmployees int
Execute @TotalEmployees = spGetTotalCountOfEmployees2
Select @TotalEmployees

--So, we are able to achieve what we want, using output parameters as well as return values. Now, let's look at example, where return status variables cannot be used, but Output parameters can be used.

--In this SP, we are retrieving the Name of the employee, based on their Id, using the output parameter @Name.

Create Procedure spGetNameById1
@Id int,
@Name nvarchar(20) Output
as
Begin
 Select @Name = Name1 from tblEmployee4 Where Id = @Id
End

--Executing spGetNameById1, prints the name of the employee
Declare @EmployeeName nvarchar(20)
Execute spGetNameById1 3, @EmployeeName out
Print 'Name of the Employee = ' + @EmployeeName

--Now let's try to achieve the same thing, using return status variables.

Create Procedure spGetNameById2
@Id int
as
Begin
 Return (Select Name1 from tblEmployee4 Where Id = @Id)
End

--Executing spGetNameById2 returns an error stating 'Conversion failed when converting the nvarchar value 'Sam' to data type int.'. The return status variable is an integer, and hence, when we select Name of an employee and try to return that we get a converion error. 

Declare @EmployeeName nvarchar(20)
Execute @EmployeeName = spGetNameById2 1
Print 'Name of the Employee = ' + @EmployeeName

--So, using return values, we can only return integers, and that too, only one integer. It is not possible, to return more than one value using return values, where as output parameters, can return any datatype and an sp can have more than one output parameters. I always prefer, using output parameters, over RETURN values.

--In general, RETURN values are used to indicate success or failure of stored procedure, especially when we are dealing with nested stored procedures.Return a value of 0, indicates success, and any nonzero value indicates failure.
