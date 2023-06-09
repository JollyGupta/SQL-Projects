use SQLPRACTICE
drop table if exists tblEmployee22
CREATE TABLE tblEmployee22
(
  Id int Primary Key,
  Name nvarchar(30),
  Gender nvarchar(10),
  DepartmentId int
)

drop table if exists tblDepartment22
CREATE TABLE tblDepartment22
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)


Insert into tblDepartment22 values (1,'IT')
Insert into tblDepartment22 values (2,'Payroll')
Insert into tblDepartment22 values (3,'HR')
Insert into tblDepartment22 values (4,'Admin')

Insert into tblEmployee22 values (1,'John', 'Male', 3)
Insert into tblEmployee22 values (2,'Mike', 'Male', 2)
Insert into tblEmployee22 values (3,'Pam', 'Female', 1)
Insert into tblEmployee22 values (4,'Todd', 'Male', 4)
Insert into tblEmployee22 values (5,'Sara', 'Female', 1)
Insert into tblEmployee22 values (6,'Ben', 'Male', 3)

--Since, we now have the required tables, let's create a view based on these tables. The view should return Employee Id, Name, Gender and DepartmentName columns. So, the view is obviously based on multiple tables.

alter view vWEmployeeDetails1
as
Select Id, [Name], Gender, DeptName
from tblEmployee22 
join tblDepartment22
on tblEmployee22.DepartmentId = tblDepartment22.DeptId


Select * from vWEmployeeDetails1 
error stating - 'View or function vWEmployeeDetails is not updatable because the modification affects multiple base tables.'

--let's try to update the view, in such a way that, it affects, both the underlying tables, and see, if we get the same error. The following UPDATE statement changes Name column from tblEmployee and DeptName column from tblDepartment. So, when we execute this query, we get the same error.

Update vWEmployeeDetails1 
set Name = 'Johny', DeptName = 'IT' --want to change 2 columns,so error
where Id = 1

Select * from vWEmployeeDetails1 --want to change 2 columns,so error

--let's try to change, just the department of John from HR to IT. The following UPDATE query, affects only one table, tblDepartment. So, the query should succeed. But, before executing the query, please note that, employees JOHN and BEN are in HR department.

Update vWEmployeeDetails1 
set DeptName = 'IT' --tried to chnge one column so wrong changes in ben's dept and 2nd wrong change is in dept table HR converted to IT in dept table also which is wrong
where Id = 1

Select * from vWEmployeeDetails1 
Select * from tblEmployee22 
Select * from tblDepartment22




Update tblDepartment22 set DeptName = 'HR' where DeptId = 3 
Select * from vWEmployeeDetails1 
Select * from tblEmployee22 
Select * from tblDepartment22



Script to create INSTEAD OF UPDATE trigger
create TRIGGER tr_vWEmployeeDetails_InsteadOfUpdate
ON vWEmployeeDetails1
INSTEAD OF UPDATE
AS
BEGIN
  -- If EmployeeId is updated
  IF (UPDATE(Id))
  BEGIN
    RAISERROR('Id cannot be changed', 16, 1);
    RETURN;
  END;
 
  -- If DeptName is updated
  IF (UPDATE(DeptName))
  BEGIN
    DECLARE @DeptId INT;
    SELECT @DeptId = DeptId  
    FROM tblDepartment22
    JOIN inserted ON inserted.DeptName = tblDepartment22.DeptName;
   
    IF (@DeptId IS NULL)
    BEGIN
      RAISERROR('Invalid Department Name', 16, 1);
      RETURN;
    END;

    UPDATE tblEmployee22
    SET DepartmentId = @DeptId
    FROM inserted
    JOIN tblEmployee22 ON tblEmployee22.Id = inserted.Id;
  END;
 
  -- If Gender is updated
  IF (UPDATE(Gender))
  BEGIN
    UPDATE tblEmployee22
    SET Gender = inserted.Gender
    FROM inserted
    JOIN tblEmployee22 ON tblEmployee22.Id = inserted.Id;
  END;
 
  -- If Name is updated
  IF (UPDATE([Name]))
  BEGIN
    UPDATE tblEmployee22
    SET [Name] = inserted.[Name]
    FROM inserted
    JOIN tblEmployee22 ON tblEmployee22.Id = inserted.Id;
  END;
END;

After correcting the errors in the trigger definition, you can try updating the view again and see if it works as expected. For example:

UPDATE vWEmployeeDetails1
SET DeptName = 'IT'
WHERE Id = 1;

Update vWEmployeeDetails1 
set [Name] = 'Johny', Gender = 'Female', DeptName = 'IT'where Id = 1

SELECT * FROM vWEmployeeDetails1; -- The department name for John should now be IT
SELECT * FROM tblEmployee22;
SELECT * FROM tblDepartment22;