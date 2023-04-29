--- how to delete duplicate records 

WITH Employees1CTE AS
(
   SELECT *, ROW_NUMBER()OVER(PARTITION BY ID ORDER BY ID) AS RowNumber
   FROM Employees1
)
DELETE FROM Employees1CTE WHERE RowNumber > 1

-- select * from Employees1CTE ; (dont use with it delete)

select * from Employees1 ;

drop table if exists Employees1;
CREATE TABLE Employees1 (
    Id int ,
    FName varchar(255),
    Gender varchar(255),
    Salary int 
    
);
  


INSERT INTO Employees1(Id,FName, Gender, Salary)
values (1, 'JG',  'F', 100), (1, 'JG',  'F', 100), (2, 'RB',  'M', 100), (2, 'RB',  'M', 100);

