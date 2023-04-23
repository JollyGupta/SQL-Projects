/*PIVOT operator turns ROWS into COLUMNS, where as UNPIVOT turns COLUMNS into ROWS.*/
drop table if exists tblProductSales;

Create Table tblProductSales
(
 SalesAgent nvarchar(50),
 India int,
 US int,
 UK int
)


Insert into tblProductSales values ('David', 960, 520, 360)
Insert into tblProductSales values ('John', 970, 540, 800)


Select  SalesAgent, India, US, UK From  tblProductSales;

/*Write a query to turn COLUMNS into ROWS.*/
SELECT SalesAgent, Country, SalesAmount
FROM tblProductSales
UNPIVOT
(
       SalesAmount
       FOR Country IN (India, US ,UK)
) AS UnpivotExample

/*Is it always possible to reverse what PIVOT operator has done using UNPIVOT operator.
No, not always. If the PIVOT operator has not aggregated the data, you can get your original data back using the UNPIVOT operator but not if the data is aggregated.*/

drop table if exists tblProductSales1;
Create Table tblProductSales1
(
     SalesAgent nvarchar(10),
     Country nvarchar(10),
     SalesAmount int
)
Go

Insert into tblProductSales1 values('David','India',960)
Insert into tblProductSales1 values('David','US',520)
Insert into tblProductSales1 values('John','India',970)
Insert into tblProductSales1 values('John','US',540)
Go

/*Let's now use the PIVOT operator to turn ROWS into COLUMNS*/

SELECT SalesAgent, India, US
FROM tblProductSales1
PIVOT
(
     SUM(SalesAmount)
     FOR Country IN (India, US)
) AS PivotTable

/*Now let's use the UNPIVOT operator to reverse what PIVOT operator has done*/

SELECT SalesAgent, Country, SalesAmount
FROM
(SELECT SalesAgent, India, US
FROM tblProductSales1
PIVOT
(
     SUM(SalesAmount)
     FOR Country IN (India, US)
) AS PivotTable) P
UNPIVOT
(
     SalesAmount
     FOR Country IN (India, US)
) AS UnpivotTable
/* if duplicate rows then sum will do sum */

Insert into tblProductSales1 values('David','India',960)
Insert into tblProductSales1 values('David','US',520)
Insert into tblProductSales1 values('John','India',970)
Insert into tblProductSales1 values('John','US',540)
Insert into tblProductSales1 values('David','India',100)

SELECT SalesAgent, India, US
FROM tblProductSales1
PIVOT
(
     SUM(SalesAmount)
     FOR Country IN (India, US)
) AS PivotTable

SELECT SalesAgent, Country, SalesAmount
FROM
(SELECT SalesAgent, India, US
FROM tblProductSales1
PIVOT
(
     SUM(SalesAmount)
     FOR Country IN (India, US)
) AS PivotTable) P
UNPIVOT
(
     SalesAmount
     FOR Country IN (India, US)
) AS UnpivotTable

select * from tblProductSales1

