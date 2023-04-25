/* SQL optimization, SQL FUNCTION, case & choose*/

drop table if exists T2Employees;
Create table T2Employees
(
 Id int primary key identity,
 F1Name nvarchar(10),
 DateOfBirth date
)


Insert into T2Employees values ('Ram', '01/11/1980')
Insert into T2Employees values ('Sita', '12/12/1981')
Insert into T2Employees values ('Hanuman', '11/21/1979')
Insert into T2Employees values ('Shiv', '05/14/1978')
Insert into T2Employees values ('Parvati', '03/17/1970')
Insert into T2Employees values ('Jolly', '04/05/1978')
Go

/*Choose function 
Returns the item at the specified index from the list of available values
The index position starts at 1 and NOT 0 (ZERO)
Syntax : CHOOSE( index, val_1, val_2, ... ) Returns the item at index position 2*/

 
SELECT CHOOSE(2, 'India','US', 'UK') AS Country

--Using CASE statement in SQL Server

SELECT F1Name, DateOfBirth,
        CASE DATEPART(MM, DateOfBirth)
            WHEN 1 THEN 'JAN'
            WHEN 2 THEN 'FEB'
            WHEN 3 THEN 'MAR'
            WHEN 4 THEN 'APR'
            WHEN 5 THEN 'MAY'
            WHEN 6 THEN 'JUN'
            WHEN 7 THEN 'JUL'
            WHEN 8 THEN 'AUG'
            WHEN 9 THEN 'SEP'
            WHEN 10 THEN 'OCT'
            WHEN 11 THEN 'NOV'
            WHEN 12 THEN 'DEC'
        END
       AS [MONTH]
FROM T2Employees

/*Using CHOOSE function in SQL Server : The amount of code we have to write is lot less than using CASE statement. The datepart function requires 2 argument(s).*/

SELECT F1Name, DateOfBirth,CHOOSE(DATEPART(MM,DateOfBirth),
       'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG',
       'SEP', 'OCT', 'NOV', 'DEC') AS [MONTH]
FROM T2Employees

/*IIF functionReturns one of two the values, depending on whether the Boolean expression evaluates to true or false IIF is a shorthand way for writing a CASE expressionSyntax : IIF ( boolean_expression, true_value, false_value ) Returns Male as the boolean expression evaluates to TRUE */

DECLARE @Gender INT
SET @Gender = 1
SELECT IIF( @Gender = 1, 'Male', 'Female') AS Gender

drop table if exists T2Employees;
Create table T3Employees
(
     Id int primary key identity,
     F3Name nvarchar(10),
     GenderId int
)
Go

Insert into T3Employees values ('Mark', 1)
Insert into T3Employees values ('John', 1)
Insert into T3Employees values ('Amy', 2)
Insert into T3Employees values ('Ben', 1)
Insert into T3Employees values ('Sara', 2)
Insert into T3Employees values ('David', 1)
Go

/*Write a query to display Gender along with employee Name and GenderId. We can achieve this either by using CASE or IIF.*/

--Using CASE statement
SELECT F3Name, GenderId,
        CASE WHEN GenderId = 1
                      THEN 'Male'
                      ELSE 'Female'
                   END AS Gender
FROM T3Employees

--Using IIF function
SELECT F3Name, GenderId, IIF(GenderId = 1, 'Male', 'Female') AS Gender
FROM T3Employees

/*TRY_PARSE function
Converts a string to Date/Time or Numeric type
Returns NULL if the provided string cannot be converted to the specified data type
Requires .NET Framework Common Language Runtime (CLR)
Syntax : TRY_PARSE ( string_value AS data_type )
Convert string to INT. As the string can be converted to INT, the result will be 99 as expected. */

SELECT TRY_PARSE('99' AS INT) AS Result
SELECT PARSE('99' AS INT) AS Result1
/*Convert string to INT. The string cannot be converted to INT, so TRY_PARSE returns NULL*/

SELECT TRY_PARSE('ABC' AS INT) AS Result2
--Error converting string value 'ABC' into data type int using culture ''
SELECT PARSE('ABC' AS INT) AS Result3

--Use CASE statement or IIF function to provide a meaningful error message instead of NULL when the conversion fails.Using CASE statement to provide a meaningful error message when the conversion fails.

SELECT
CASE WHEN TRY_PARSE('ABC' AS INT) IS NULL
           THEN 'Conversion Failed'
           ELSE 'Conversion Successful'
END AS Result


--difference between PARSE and TRY_PARSE PARSE will result in an error if the conversion fails, where as TRY_PARSE will return NULL instead of an error. 

--ABC cannot be converted to INT, PARSE will return an error
SELECT PARSE('ABC' AS INT) AS Result

--Since ABC cannot be converted to INT, TRY_PARSE will return NULL instead of an error
SELECT TRY_PARSE('ABC' AS INT) AS Result

--Using IIF function to provide a meaningful error message when the conversion fails.

SELECT IIF(TRY_PARSE('ABC' AS INT) IS NULL, 'Conversion Failed',
                 'Conversion Successful') AS Result

Create table T4Employees
(
     Id int primary key identity,
     F4Name nvarchar(10),
     Age nvarchar(10)
)
Go

Insert into T4Employees values ('Mark', '40')
Insert into T4Employees values ('John', '20')
Insert into T4Employees values ('Amy', 'THIRTY')
Insert into T4Employees values ('Ben', '21')
Insert into T4Employees values ('Sara', 'FIFTY')
Insert into T4Employees values ('David', '25')
Go

--The data type of Age column is nvarchar. So string values like (THIRTY, FIFTY ) are also stored. Now, we want to write a query to convert the values in Age column to int and return along with the Employee name. Notice TRY_PARSE function returns NULL for the rows where age cannot be converted to INT.

SELECT F4Name, TRY_PARSE(Age AS INT) AS Age
FROM T4Employees
/*SELECT F4Name, TRY_PARSE(Age AS nchar) AS Age
FROM T4Employees*/  ?

--Error converting string value 'THIRTY' into data type int using culture ''.

SELECT F4Name, PARSE(Age AS INT) AS Age
FROM T4Employees

--TRY_CONVERT function Converts a value to the specified data type Returns NULL if the provided value cannot be converted to the specified data type If you request a conversion that is explicitly not permitted, then TRY_CONVERT fails with an error
 --TRY_CONVERT ( data_type, value, [style] ) Style parameter is optional. The range of acceptable values is determined by the target data_type. For the list of all possible values for style parameter, please visit the following MSDN article 
 -- https://msdn.microsoft.com/en-us/library/ms187928.aspx
--Convert string to INT. As the string can be converted to INT, the result will be 99 as expected.

SELECT TRY_CONVERT(INT, '99') AS Result

 --Convert string to INT. The string cannot be converted to INT, so TRY_CONVERT returns NULL
SELECT TRY_CONVERT(INT, 'ABC') AS Result

--Converting an integer to XML is not explicitly permitted. so in this case TRY_CONVERT fails with an error

SELECT TRY_CONVERT(XML, 10) AS Result

--If you want to provide a meaningful error message instead of NULL when the conversion fails, you can do so using CASE statement or IIF function.
-- Using CASE statement to provide a meaningful error message when the conversion fails.

SELECT
CASE WHEN TRY_CONVERT(INT, 'ABC') IS NULL
           THEN 'Conversion Failed'
           ELSE 'Conversion Successful'
END AS Result

SELECT IIF(TRY_CONVERT(INT, 'ABC') IS NULL, 'Conversion Failed',
                 'Conversion Successful') AS Result

--What is the difference between CONVERT and TRY_CONVERT
--CONVERT will result in an error if the conversion fails, where as TRY_CONVERT will return NULL instead of an error. 

--Since ABC cannot be converted to INT, CONVERT will return an error
SELECT CONVERT(INT, 'ABC') AS Result

--Since ABC cannot be converted to INT, TRY_CONVERT will return NULL instead of an error
SELECT TRY_CONVERT(INT, 'ABC') AS Result

---Using TRY_CONVERT() function with table data. We will use the following Employees table for this example.
drop table if exists T4Employees;
Create table T4Employees
(
     Id int primary key identity,
     F4Name nvarchar(10),
     Age nvarchar(10)
)
Go

Insert into T4Employees values ('Mark', '40')
Insert into T4Employees values ('John', '20')
Insert into T4Employees values ('Amy', 'THIRTY')
Insert into T4Employees values ('Ben', '21')
Insert into T4Employees values ('Sara', 'FIFTY')
Insert into T4Employees values ('David', '25')
Go

SELECT F4Name, TRY_CONVERT(INT, Age) AS Age
FROM T4Employees

--Conversion failed when converting the nvarchar value 'THIRTY' to data type int.
SELECT F4NAME, CONVERT(INT, Age) AS Age
FROM T4Employees

--Difference between TRY_PARSE and TRY_CONVERT functions TRY_PARSE can only be used for converting from string to date/time or number data types where as TRY_CONVERT can be used for any general type conversions.

--you can use TRY_CONVERT to convert a string to XML data type, where as you can do the same using TRY_PARSE

--Converting a string to XML data type using TRY_CONVERT
SELECT TRY_CONVERT(XML, '<root><child/></root>') AS [XML]

--The above query produces the following
--try_parse vs try_convert sql server

--converting a string to XML data type using TRY_PARSE
SELECT TRY_PARSE('<root><child/></root>' AS XML) AS [XML]
--Invalid data type xml in function TRY_PARSE

--difference is TRY_PARSE relies on the presence of .the .NET Framework Common Language Runtime (CLR) where as TRY_CONVERT does not.

--DateTime2FromParts function
/*The data type of all the parameters is integer
If invalid argument values are specified, the function returns an error
If any of the required arguments are NULL, the function returns null
If the precision argument is null, the function returns an error
Syntax : DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision )*/

-- All the function arguments have valid values, so DATETIME2FROMPARTS returns DATETIME2 value as expected.

SELECT DATETIME2FROMPARTS ( 2015, 11, 15, 20, 55, 55, 0, 0 ) AS [DateTime2]

SELECT DATETIME2FROMPARTS ( 2015, 15, 15, 20, 55, 55, 0, 0 ) AS [DateTime2]
--Error Cannot construct data type datetime2, some of the arguments have values which are not valid. 15 month no

--If any of the required arguments are NULL, the function returns null. NULL specified for month parameter, so the function returns NULL.
SELECT DATETIME2FROMPARTS ( 2015, NULL, 15, 20, 55, 55, 0, 0 ) AS [DateTime2]

--If the precision argument is null, the function returns an error

SELECT DATETIME2FROMPARTS ( 2015, 15, 15, 20, 55, 55, 0, NULL ) AS [DateTime2]
--Error Scale argument is not valid. Valid expressions for data type datetime2 scale argument are integer constants and integer constant expressions.

--TIMEFROMPARTS : Returns time value Syntax : TIMEFROMPARTS ( hour, minute, seconds, fractions, precision )

SELECT TIMEFROMPARTS ( 20, 55, 55, 0, NULL ) AS [DateTime2]
SELECT TIMEFROMPARTS ( 20, 55, 55, 1, 2) AS [DateTime2] --.01 1/10 
SELECT TIMEFROMPARTS ( 20, 55, 55, 1, 4) AS [DateTime2] --.0001 1/1000

/*EOMONTH function
Returns the last day of the month of the specified date
EOMONTH ( start_date [, month_to_add ] )
start_date : The date for which to return the last day of the month
month_to_add : Optional. Number of months to add to the start_date. EOMONTH adds the specified number of months to start_date, and then returns the last day of the month for the resulting date.
Example : Returns last day of the month November */

SELECT EOMONTH('11/20/2015') AS LastDay
SELECT EOMONTH('02/11/1984') AS LastDay

SELECT EOMONTH('3/20/2016', 2) AS LastDay
SELECT EOMONTH('3/20/2016', -1) AS LastDay

Create table T5Employees
(
    Id int primary key identity,
    F5Name nvarchar(10),
    DateOfBirth date
)
Go

Insert into T5Employees values ('Mark', '01/11/1980')
Insert into T5Employees values ('John', '12/12/1981')
Insert into T5Employees values ('Amy', '11/21/1979')
Insert into T5Employees values ('Ben', '05/14/1978')
Insert into T5Employees values ('Sara', '03/17/1970')
Insert into T5Employees values ('David', '04/05/1978')
Go

SELECT F5Name, DateOfBirth, EOMONTH(DateOfBirth) AS LastDay
FROM T5Employees

--last day instead of the full date, you can use DATEPART function
SELECT F5Name, DateOfBirth, DATEPART(DD,EOMONTH(DateOfBirth)) AS LastDay
FROM T5Employees

--Difference between DateTime and SmallDateTime in SQL Server
--The following 2 queries have values outside of the range of SmallDateTime data type.

drop table if exists T6Employees;
Create table T6Employees
(
    Date1 Date,
    SmallDateTime1 SmallDateTime,
	DateTime1 DateTime,
	Date2 DATETIME2
)
Go

/* no error but in video there is an error at that time https://www.youtube.com/watch?v=4lXpR6GdHo0&t=30s */

Insert into T6Employees ([SmallDateTime1]) values ('01/01/1899')
Insert into T6Employees ([SmallDateTime1]) values ('07/06/2079')

Select * from T6Employees
truncate table T6Employees

/* time is not displaying */

Insert into T6Employees ([SmallDateTime1]) values ('2023-04-25 14:56:59')
Select  SmallDateTime1, DateTime1  from T6Employees
truncate table T6Employees

Insert into T6Employees ([SmallDateTime1]) values ('2023-04-25 14:56:51')
Insert into T6Employees ([SmallDateTime1]) values ('2023-04-25 14:56:52')
Insert into T6Employees ([SmallDateTime1]) values ('2023-04-25 14:56:53')
Insert into T6Employees ([SmallDateTime1]) values ('2023-04-25 14:56:54')
Insert into T6Employees ([SmallDateTime1]) values ('2023-04-25 14:56:55')
Insert into T6Employees ([SmallDateTime1]) values ('2023-04-25 14:56:56')
Insert into T6Employees ([SmallDateTime1]) values ('2023-04-25 14:56:57')
Insert into T6Employees ([SmallDateTime1]) values ('2023-04-25 14:56:58')
Insert into T6Employees ([SmallDateTime1]) values ('2023-04-25 14:56:59')


Insert into T6Employees ([DateTime1]) values ('2023-04-25 14:56:52')
Insert into T6Employees ([DateTime1]) values ('2023-04-25 14:56:53')
Insert into T6Employees ([DateTime1]) values ('2023-04-25 14:56:54')
Insert into T6Employees ([DateTime1]) values ('2023-04-25 14:56:55')
Insert into T6Employees ([DateTime1]) values ('2023-04-25 14:56:56')
Insert into T6Employees ([DateTime1]) values ('2023-04-25 14:56:57')
Insert into T6Employees ([DateTime1]) values ('2023-04-25 14:56:58')
Insert into T6Employees ([DateTime1]) values ('2023-04-25 14:56:59')


drop table if exists T6Employees;
Create table T6Employees
(
    Date1 Date,
    SmallDateTime1 SmallDateTime,
	DateTime1 DateTime,
	Date2 DATETIME2
)
Go
Insert into T6Employees  values (getdate(),getdate(),getdate(),getdate())

select * from T6Employees 
select getdate()
select getdate()-1 