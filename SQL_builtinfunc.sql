--Functions in SQL server can be broadly divided into 2 categoris
1. Built-in functions
2. User Defined functions

 --Built in string functions
Left, Reight, Charindex and Substring functions
Replicate, Space, Patindex, Replace and Stuff functions
 --DateTime functions
IsDate, Day, Month, Year and DateName functions
DatePart, DateAdd and DateDiff functions
Convert and Cast functions

--Mathematical functions


--ASCII(Character_Expression) - Returns the ASCII code of the given character expression. To find the ACII Code of capital letter 'A'-65

Select ASCII('A')

--CHAR(Integer_Expression) - Converts an int ASCII code to a character. The Integer_Expression, should be between 0 and 255.

--The following SQL, prints all the characters for the ASCII values from o thru 255

Declare @Number int
Set @Number = 1
While(@Number <= 255)
Begin
 Print Char(@Number)
 Set @Number = @Number + 1
End

--Note: The while loop will become an infinite loop, if you forget to include the following line. Set @Number = @Number + 1

--Printing uppercase alphabets using CHAR() function:

Declare @Number int
Set @Number = 65
While(@Number <= 90)
Begin
 Print CHAR(@Number)
 Set @Number = @Number + 1
End

--Printing lowercase alphabets using CHAR() function:

Declare @Number int
Set @Number = 97
While(@Number <= 122)
Begin
 Print CHAR(@Number)
 Set @Number = @Number + 1
End


--Another way of printing lower case alphabets using CHAR() and LOWER() functions.

Declare @Number int
Set @Number = 65
While(@Number <= 90)
Begin
 Print LOWER(CHAR(@Number))
 Set @Number = @Number + 1
End

--LTRIM(Character_Expression) - Removes blanks on the left handside of the given character expression.

--Example: Removing the 3 white spaces on the left hand side of the '   Hello' string using LTRIM() function.
Select ('   Hello')
Select LTRIM('   Hello')

--RTRIM(Character_Expression) - Removes blanks on the right hand side of the given character expression.
--Removing the 3 white spaces on the left hand side of the 'Hello   ' string using RTRIM() function.

Select ('Hello   ')
Select RTRIM('Hello   ')


--To remove white spaces on either sides of the given character expression, use LTRIM() and RTRIM() as shown below.

Select LTRIM(RTRIM('   Hello   '))


--LOWER(Character_Expression) - Converts all the characters in the given Character_Expression, to lowercase letters.

Select LOWER('CONVERT This String Into Lower Case')


--UPPER(Character_Expression) - Converts all the characters in the given Character_Expression, to uppercase letters.

Select UPPER('CONVERT This String Into upper Case')


--REVERSE('Any_String_Expression') - Reverses all the characters in the given string expression.
 Select REVERSE('ABCDEFGHIJKLMNOPQRSTUVWXYZ')


--LEN(String_Expression) - Returns the count of total characters, in the given string expression, excluding the blanks at the end of the expression.

Select LEN('SQL Functions   ')

--LEFT(Character_Expression, Integer_Expression) - Returns the specified number of characters from the left hand side of the given character expression.

Select LEFT('ABCDE', 3)


--RIGHT(Character_Expression, Integer_Expression) - Returns the specified number of characters from the right hand side of the given character expression.

Select RIGHT('ABCDE', 3)


--CHARINDEX('Expression_To_Find', 'Expression_To_Search', 'Start_Location') - Returns the starting position of the specified expression in a character string. Start_Location parameter is optional.

--In this example, we get the starting position of '@' character in the email string 'sara@aaa.com'. 

Select CHARINDEX('@','sara@aaa.com')
Select CHARINDEX('@','sara@aaa.com',1)


--SUBSTRING('Expression', 'Start', 'Length') - As the name, suggests, this function returns substring (part of the string), from the given expression. You specify the starting location using the 'start' parameter and the number of characters in the substring using 'Length' parameter. All the 3 parameters are mandatory.

--Display just the domain part of the given email 'John@bbb.com'.
--b to m total 7
Select SUBSTRING('John@bbb.com',6, 7)


--In the above example, we have hardcoded the starting position and the length parameters. Instead of hardcoding we can dynamically retrieve them using CHARINDEX() and LEN() string functions as shown below.
-- charindex return @+1= first b, len return 11 - 4= 7 firstb 

Select SUBSTRING('pam@bbb.com',4, 7)
Select SUBSTRING('pam@bbb.com',CHARINDEX('@', 'pam@bbb.com'), 7)
Select SUBSTRING('pam@bbb.com',CHARINDEX('@', 'pam@bbb.com')+1, 7)

Select SUBSTRING('pam@bbb.com',(CHARINDEX('@', 'pam@bbb.com') + 1), (LEN('pam@bbb.com') - CHARINDEX('@','pam@bbb.com')))

drop table if exists tblEmployee5;

--SQL Script to create tblEmployee and tblDepartment tables

Create table tblEmployee5
(
     Id int primary key,
     FirstName nvarchar(50),
     LastName nvarchar(50),
	 Email nvarchar(50)
)
Go

Insert into tblEmployee5 values (1, 'mike', 'Gupta','mmm@gmail.com')
Insert into tblEmployee5 values (2, 'aike', 'Singhaniya','aaa@msn.com')
Insert into tblEmployee5 values (3, 'bike', 'Tripathi','bbb@rediffmail.com')
Insert into tblEmployee5 values (4, 'cike', 'Pandey','ccc@gmail.com')
Insert into tblEmployee5 values (5, 'dike', 'Jain','ddd@gmail.com')
Insert into tblEmployee5 values (6, 'eike', 'Garg','eee@gmail.com')
Insert into tblEmployee5 values (7, 'fike', 'Agarwal','fff@gmail.com')

Select SUBSTRING(Email, CHARINDEX('@', Email) + 1,
LEN(Email) - CHARINDEX('@', Email)) as EmailDomain,
COUNT(Email) as Total
from tblEmployee5

Group By SUBSTRING(Email, CHARINDEX('@', Email) + 1,
LEN(Email) - CHARINDEX('@', Email))


--REPLICATE(String_To_Be_Replicated, Number_Of_Times_To_Replicate) - Repeats the given string, for the specified number of times.

SELECT REPLICATE('SQL Jolly', 3)

select SUBSTRING(Email, 1, 2) from tblEmployee5

Select FirstName, LastName, SUBSTRING(Email, 1, 2) + REPLICATE('*',1) + 
SUBSTRING(Email, CHARINDEX('@',Email), LEN(Email) - CHARINDEX('@',Email)+1) as Email
from tblEmployee5

Select FirstName, LastName, SUBSTRING(Email, 1, 2) + REPLICATE('*',5) + 
SUBSTRING(Email, CHARINDEX('@',Email), LEN(Email) - CHARINDEX('@',Email)+1) as Email
from tblEmployee5

SPACE(Number_Of_Spaces) - Returns number of spaces, specified by the Number_Of_Spaces argument.

--The SPACE(5) function, inserts 5 spaces between FirstName and LastName

Select FirstName + SPACE(5) + LastName as FullName
From tblEmployee5

--PATINDEX('%Pattern%', Expression)
--Returns the starting position of the first occurrence of a pattern in a specified expression. It takes two arguments, the pattern to be searched and the expression. PATINDEX() is simial to CHARINDEX(). With CHARINDEX() we cannot use wildcards, where as PATINDEX() provides this capability. If the specified pattern is not found, PATINDEX() returns ZERO.

Select Email, PATINDEX('%@gmail.com', Email) as FirstOccurence 
from tblEmployee5

Select Email, PATINDEX('%@gmail.com', Email) as FirstOccurence 
from tblEmployee5
Where PATINDEX('%@gmail.com', Email) > 0

--REPLACE(String_Expression, Pattern , Replacement_Value)
--Replaces all occurrences of a specified string value with another string value.
--All .COM strings are replaced with .NET

Select Email, REPLACE(Email, '.com', '.net') as ConvertedEmail
from  tblEmployee5

--STUFF(Original_Expression, Start, Length, Replacement_expression)
--STUFF() function inserts Replacement_expression, at the start position specified, along with removing the charactes specified using Length parameter.
--starting from 2nd m, to @ total mm@ 3 

Select FirstName, LastName,Email, STUFF(Email, 2, 3, '*****') as StuffedEmail
From tblEmployee5

--DateTime functions
1. DateTime data types
2. DateTime functions available to select the current system date and time
3. Understanding concepts - UTC time and Time Zone offset

CREATE TABLE [tblDateTime]
(
 [c_time] [time](7) NULL,
 [c_date] [date] NULL,
 [c_smalldatetime] [smalldatetime] NULL,
 [c_datetime] [datetime] NULL,
 [c_datetime2] [datetime2](7) NULL,
 [c_datetimeoffset] [datetimeoffset](7) NULL
)

INSERT INTO tblDateTime VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

select* from tblDateTime

--Cast and Convert functions in SQL Server -
--To convert one data type to another, CAST and CONVERT functions can be used. 

--Syntax of CAST and CONVERT functions from MSDN:
CAST ( expression AS data_type [ ( length ) ] )
CONVERT ( data_type [ ( length ) ] , expression [ , style ] )

From the syntax, it is clear that CONVERT() function has an optional style parameter,where as CAST() function lacks this capability.

use SQLPRACTICE
drop table if exists tblEmployee6;
Create table tblEmployee6
(
     Id int primary key,
     Name1 nvarchar(50),
     DateOfBirth smalldatetime,
)
Go

Insert into tblEmployee6 values (1, 'mike', '1983-09-29 2:16:00')
Insert into tblEmployee6 values (2, 'aike', '1982-09-26 3:24:00')
Insert into tblEmployee6 values (3, 'bike', '1981-09-25 2:17:00')
Insert into tblEmployee6 values (4, 'cike', '1980-09-24 2:12:00')

Select Id, Name1, DateOfBirth, CAST(DateofBirth as nvarchar) as ConvertedDOB
from tblEmployee6
Select Id, Name1, DateOfBirth, Convert(nvarchar, DateOfBirth) as ConvertedDOB
from tblEmployee6

--let's use the style parameter of the CONVERT() function, to format the Date as we would like it. In the query below, we are using 103 as the argument for style parameter, which formats the date as dd/mm/yyyy.

Select Id, Name1, DateOfBirth, Convert(nvarchar, DateOfBirth, 103) as ConvertedDOB
from tblEmployee6

--To get just the date part, from DateTime
SELECT CONVERT(VARCHAR(10),GETDATE(),101)
SELECT CONVERT(nvarchar(10),DateOfBirth,101) as ConvertedDOB
from tblEmployee6


--In SQL Server 2008, Date datatype is introduced, so you can also use
SELECT CAST(GETDATE() as DATE)
SELECT CONVERT(DATE, GETDATE())

--Note: To control the formatting of the Date part, DateTime has to be converted to NVARCHAR using the styles provided. When converting to DATE data type, the CONVERT() function will ignore the style parameter.


use SQLPRACTICE
drop table if exists tblEmployee7;
Create table tblEmployee7
(
     Id int primary key,
     Name1 nvarchar(50)
     
)
Go

Insert into tblEmployee7 values (1, 'mike')
Insert into tblEmployee7 values (2, 'aike')
Insert into tblEmployee7 values (3, 'bike')
Insert into tblEmployee7 values (4, 'cike')

--In this query, we are using CAST() function, to convert Id (int) to nvarchar, so it can be appended with the NAME column. If you remove the CAST() function, you will get an error stating - 'Conversion failed when converting the nvarchar value 'Sam - ' to data type int.'

Select Id, Name1, Name1 + ' - ' + Id AS [Name-Id]
FROM tblEmployee7

Select Id, Name1, Name1 + ' - ' + CAST(Id AS NVARCHAR) AS [Name-Id]
FROM tblEmployee7

use SQLPRACTICE
drop table if exists tblEmployee8;
Create table tblEmployee8
(
     Id int primary key,
     Name1 nvarchar(50),
	 email nvarchar(50),
	 RegisteredDate datetime
     
)
Go

Insert into tblEmployee8 values (1, 'mike','mm@gmail.com', '2023-05-04 11:54:02:00')
Insert into tblEmployee8 values (2, 'aike','aa@gmail.com', '2023-05-04 11:54:03:00')
Insert into tblEmployee8 values (3, 'bike', 'bb@gmail.com', '2023-05-03 11:54:04:00')
Insert into tblEmployee8 values (4, 'cike', 'cc@gmail.com', '2023-05-04 11:54:01:00')

Select RegisteredDate, COUNT(Id) as TotalRegistrations
From tblEmployee8 
Group By RegisteredDate
--because time is different so can't group by datewise

Select CAST(RegisteredDate as DATE) as RegistrationDate,
COUNT(Id) as TotalRegistrations
From tblEmployee8 
Group By CAST(RegisteredDate as DATE)
----no matter time is different can group by datewise so there is need for cast function

/*1. Cast is based on ANSI standard and Convert is specific to SQL Server. So, if portability is a concern and if you want to use the script with other database applications, use Cast(). 
2. Convert provides more flexibility than Cast. For example, it's possible to control how you want DateTime datatypes to be converted using styles with convert function.

The general guideline is to use CAST(), unless you want to take advantage of the style functionality in CONVERT().*/


--IsDate, Day, Month, Year and DateName DateTime functions in SQL Server 
--ISDATE() - Checks if the given value, is a valid date, time, or datetime. Returns 1 for success, 0 for failure.

Select ISDATE('PRAGIM') -- returns 0
Select ISDATE(Getdate()) -- returns 1
Select ISDATE('2012-08-31 21:02:04.167') -- returns 1

--Note: For datetime2 values, IsDate returns ZERO.

Select ISDATE('2012-09-01 11:34:21.1918447') -- returns 0.

--Day() - Returns the 'Day number of the Month' of the given date

Select DAY(GETDATE()) -- Returns the day number of the month, based on current system datetime.

Select DAY('05/04/2023') -- Returns 4th may today

--Month() - Returns the 'Month number of the year' of the given date

Select Month(GETDATE()) -- Returns the Month number of the year, based on the current system date and time
Select Month('05/04/2023') -- Returns 1

--Year() - Returns the 'Year number' of the given date

Select Year(GETDATE()) -- Returns the year number, based on the current system date
Select Year('05/04/2023') -- Returns 2012

--DateName(DatePart, Date) - Returns a string, that represents a part of the given date. This functions takes 2 parameters. The first parameter 'DatePart' specifies, the part of the date, we want. The second parameter, is the actual date, from which we want the part of the Date.

Select DATENAME(Day, '2023-05-04 12:43:46.837') -- Returns 4 date
Select DATENAME(WEEKDAY, '2023-05-04 12:43:46.837') -- Returns thrusday
Select DATENAME(MONTH, '2012-05-04 12:43:46.837') -- Returns may

use SQLPRACTICE
drop table if exists tblEmployee9;
Create table tblEmployee9
(
     Id int primary key,
     Name1 nvarchar(50),
     DateOfBirth datetime,
)
Go

Insert into tblEmployee9 values (1, 'mike', '1983-09-29 2:16:00')
Insert into tblEmployee9 values (2, 'aike', '1982-09-26 3:24:00')
Insert into tblEmployee9 values (3, 'bike', '1981-09-25 2:17:00')
Insert into tblEmployee9 values (4, 'cike', '1980-09-24 2:12:00')

Select Name1, DateOfBirth, DateName(WEEKDAY,DateOfBirth) as [Dayname], 
            Month(DateOfBirth) as MonthNumber, 
            DateName(MONTH, DateOfBirth) as [MonthName],
            Year(DateOfBirth) as [Year]

From   tblEmployee9

--DatePart, DateAdd and DateDiff functions
--DatePart(DatePart, Date) - Returns an integer representing the specified DatePart. This function is simialar to DateName(). DateName() returns nvarchar, where as DatePart() returns an integer. The valid DatePart parameter values are shown below.

Select DATEPART(weekday, '2023-05-04 19:45:31.793') -- returns 5
Select DATENAME(weekday, '2023-05-04 19:45:31.793') -- returns Thursday

--DATEADD (datepart, NumberToAdd, date) - Returns the DateTime, after adding specified NumberToAdd, to the datepart specified of the given date.

Select DateAdd(DAY, 2, '2023-08-28 19:45:31.793') 
-- Returns 2012-09-19 19:45:31.793
Select DateAdd(DAY, -20, '2023-08-30 19:45:31.793') 
-- Returns 2012-08-10 19:45:31.793

--DATEDIFF(datepart, startdate, enddate) - Returns the count of the specified datepart boundaries crossed between the specified startdate and enddate.

Select DATEDIFF(MONTH, '11/30/2005','01/31/2006') -- returns 2 months
Select DATEDIFF(DAY, '11/30/2005','01/31/2006') -- returns 62 days
---very very imp
https://csharp-video-tutorials.blogspot.com/2012/09/datepart-dateadd-and-datediff-functions.html
use SQLPRACTICE
drop table if exists tblEmployee9;
Create table tblEmployee10
(
     Id int primary key,
     Name1 nvarchar(50),
     DateOfBirth datetime,
)
Go

Insert into tblEmployee10 values (1, 'mike', '1983-09-29 2:16:00')
Insert into tblEmployee10 values (2, 'aike', '1982-09-26 3:24:00')
Insert into tblEmployee10 values (3, 'bike', '1981-09-25 2:17:00')
Insert into tblEmployee10 values (4, 'cike', '1980-09-24 2:12:00')

CREATE FUNCTION fnComputeAge(@DOB DATETIME)
RETURNS NVARCHAR(50)
AS
BEGIN

DECLARE @tempdate DATETIME, @years INT, @months INT, @days INT
SELECT @tempdate = @DOB

SELECT @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - CASE WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE())) THEN 1 ELSE 0 END
SELECT @tempdate = DATEADD(YEAR, @years, @tempdate)

SELECT @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - CASE WHEN DAY(@DOB) > DAY(GETDATE()) THEN 1 ELSE 0 END
SELECT @tempdate = DATEADD(MONTH, @months, @tempdate)

SELECT @days = DATEDIFF(DAY, @tempdate, GETDATE())

DECLARE @Age NVARCHAR(50)
SET @Age = Cast(@years AS  NVARCHAR(4)) + ' Years ' + Cast(@months AS  NVARCHAR(2))+ ' Months ' +  Cast(@days AS  NVARCHAR(2))+ ' Days Old'
RETURN @Age

End

--Using the function in a query to get the expected output along with the age of the person.
Select Id, Name1, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from tblEmployee10
==============================================

--Mathematical functions
--ABS ( numeric_expression ) - ABS stands for absolute and returns, the absolute (positive) number. 

Select ABS(-101.5)                  -- returns 101.5, without the - sign.


--CEILING ( numeric_expression ) and FLOOR ( numeric_expression )
--CEILING and FLOOR functions accept a numeric expression as a single parameter. CEILING() returns the highest integer value greater than or equal to the parameter, whereas FLOOR() returns the smallest integer less than or equal to the parameter. 

-ceiling top , floor bottom 

Select CEILING(15.2) -- Returns 16
Select CEILING(-15.2) -- Returns -15  -16 less than -15

Select FLOOR(15.2) -- Returns 15  
Select FLOOR(-15.2) -- Returns -16  

--Power(expression, power) - Returns the power value of the specified expression to the specified power.

--The following example calculates '2 TO THE POWER OF 3' = 2*2*2 = 8
Select POWER(2,3) -- Returns 8

--RAND([Seed_Value]) - Returns a random float number between 0 and 1. Rand() function takes an optional seed parameter. When seed value is supplied the 
--RAND() function always returns the same value for the same seed.

Select RAND(1) -- Always returns the same value

--If you want to generate a random number between 1 and 100, RAND() and FLOOR() functions can be used as shown below. Every time, you execute this query, you get a random number between 1 and 100.

Select FLOOR(RAND() * 100)

--The following query prints 10 random numbers between 1 and 100.

Declare @Counter INT
Set @Counter = 1
While(@Counter <= 10)
Begin
 Print FLOOR(RAND() * 100)
 Set @Counter = @Counter + 1
End

--SQUARE ( Number ) - Returns the square of the given number.
Select SQUARE(9) -- Returns 81

--SQRT ( Number ) - SQRT stands for Square Root. This function returns the square root of the given value.

Select SQRT(81) -- Returns 9

--ROUND ( numeric_expression , length [ ,function ] ) - Rounds the given numeric expression based on the given length. This function takes 3 parameters. 

1. Numeric_Expression is the number that we want to round.
2. Length parameter, specifies the number of the digits that we want to round to. If the length is a positive number, then the rounding is applied for the decimal part, where as if the length is negative, then the rounding is applied to the number before the decimal.
3. The optional function parameter, is used to indicate rounding or truncation operations. A value of 0, indicates rounding, where as a value of non zero indicates truncation. Default, if not specified is 0.

-- Round to 2 places after (to the right) the decimal point
Select ROUND(850.556, 2) -- Returns 850.560

-- Truncate anything after 2 places, after (to the right) the decimal point
Select ROUND(850.556, 2, 1) -- Returns 850.550 1 means truncate

-- Round to 1 place after (to the right) the decimal point
Select ROUND(850.556, 1) -- Returns 850.600

-- Truncate anything after 1 place, after (to the right) the decimal point
Select ROUND(850.556, 1, 1) -- Returns 850.500

-- Round the last 2 places before (to the left) the decimal point
Select ROUND(850.556, -2) -- 900.000 ???

-- Round the last 1 place before (to the left) the decimal point
Select ROUND(850.556, -1) -- 850.000 ??


