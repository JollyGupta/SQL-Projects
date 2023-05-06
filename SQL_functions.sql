/*Scalar User Defined functions
Inline Table Valued functions
Multi-Statement Table Valued functions*/

--3 types of User Defined functions
1. Scalar functions
2. Inline table-valued functions
3. Multistatement table-valued functions

--Scalar functions may or may not have parameters, but always return a single (scalar) value. The returned value can be of any data type, except text, ntext, image, cursor, and timestamp.

--To create a function, we use the following syntax:
CREATE FUNCTION Function_Name(@Parameter1 DataType, @Parameter2 DataType,..@Parametern Datatype)
RETURNS Return_Datatype
AS
BEGIN
    Function Body
    Return Return_Datatype
END

--Let us now create a function which calculates and returns the age of a person. To compute the age we require, date of birth. So, let's pass date of birth as a parameter. So, AGE() function returns an integer and accepts date parameter.

--logic uncleared to me ????????????????

CREATE FUNCTION Age(@DOB Date)  
RETURNS INT  
AS  
BEGIN  
 DECLARE @Age INT  
 SET @Age = DATEDIFF(YEAR, @DOB, GETDATE()) - CASE WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE())) THEN 1 ELSE 0 END  
 RETURN @Age  
END


--When calling a scalar user-defined function, you must supply a two-part name, OwnerName.FunctionName. dbo stands for database owner.

Select dbo.Age( dbo.Age('10/08/1982')

--You can also invoke it using the complete 3 part name, DatabaseName.OwnerName.FunctionName.

Select SampleDB.dbo.Age('10/08/1982')

--Scalar user defined functions can be used in the Select clause as shown below.

Select Name, DateOfBirth, dbo.Age(DateOfBirth) as Age from tblEmployees

--Scalar user defined functions can be used in the Where clause, as shown below.

Select Name, DateOfBirth, dbo.Age(DateOfBirth) as Age 
from tblEmployees
Where dbo.Age(DateOfBirth) > 30

--A stored procedure also can accept DateOfBirth and return Age, but you cannot use stored procedures in a select or where clause. This is just one difference between a function and a stored procedure. There are several other differences, which we will talk about in a later session.

--To alter a function we use ALTER FUNCTION FuncationName statement and to delete it, we use DROP FUNCTION FuncationName.

--To view the text of the function use sp_helptext FunctionName


--a scalar function, returns a single value. on the other hand, an Inline Table Valued function, return a table. 

--Syntax for creating an inline table valued function

CREATE FUNCTION Function_Name(@Param1 DataType, @Param2 DataType..., @ParamN DataType)
RETURNS TABLE
AS
RETURN (Select_Statement)


use SQLPRACTICE

drop table if exists tblEmployee11;
Create table tblEmployee11
(
     Id int primary key,
     [Name] nvarchar(50),
     DateOfBirth datetime,
	 Gender nvarchar(50),
	 DepartmentId int
)
Go

Insert into tblEmployee11 values (1, 'Sam', '1983-09-29 2:16:00','M',1)
Insert into tblEmployee11 values (2, 'pam', '1982-09-26 3:24:00','F',2)
Insert into tblEmployee11 values (3, 'john', '1981-09-25 2:17:00','M',1)
Insert into tblEmployee11 values (4, 'sara', '1980-09-24 2:12:00','F',3)
Insert into tblEmployee11 values (5, 'todd', '1980-09-24 2:12:00','M',1)

--Create a function that returns EMPLOYEES by GENDER.

CREATE FUNCTION fn_EmployeesByGender(@Gender nvarchar(10))
RETURNS TABLE
AS
RETURN (Select Id, [Name], DateOfBirth, Gender, DepartmentId
      from tblEmployee11
      where Gender = @Gender)

--Calling the user defined function

Select * from fn_EmployeesByGender('M')

/*If you look at the way we implemented this function, it is very similar to SCALAR function, with the following differences
1. We specify TABLE as the return type, instead of any scalar data type
2. The function body is not enclosed between BEGIN and END block. Inline table valued function body, cannot have BEGIN and END block.
3. The structure of the table that gets returned, is determined by the SELECT statement with in the function.*/

--As the inline user defined function, is returning a table, issue the select statement against the function, as if you are selecting the data from a TABLE.

--Where can we use Inline Table Valued functions

--Inline Table Valued functions can be used to achieve the functionality of parameterized views. 
--The table returned by the table valued function, can also be used in joins with other tables.