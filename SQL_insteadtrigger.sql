--INSTEAD OF UPDATE trigger. 
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


Create view vWEmployeeDetails1
as
Select Id, [Name], Gender, DeptName
from tblEmployee22 
join tblDepartment22
on tblEmployee22.DepartmentId = tblDepartment22.DeptId


Select * from vWEmployeeDetails1 
error stating - 'View or function vWEmployeeDetails is not updatable because the modification affects multiple base tables.'


Update vWEmployeeDetails1 
set Name = 'Johny', DeptName = 'IT' --want to change 2 columns,so error
where Id = 1

Select * from vWEmployeeDetails1 --want to change 2 columns,so error



Update vWEmployeeDetails1 
set DeptName = 'IT' --tried to chnge one column so wrong changes in ben's dept and 2nd wrong change is in dept table HR converted to IT in dept table also which is wrong
where Id = 1

Select * from vWEmployeeDetails1 
Select * from tblEmployee22 
Select * from tblDepartment22


Update tblDepartment22 set DeptName = 'HR' where DeptId = 3 

--Script to create INSTEAD OF UPDATE trigger: see trigger on views 
Alter Trigger tr_vWEmployeeDetails_InsteadOfUpdate
on vWEmployeeDetails1
instead of update
as
Begin
 -- if EmployeeId is updated
 if(Update(Id))
 Begin
  Raiserror('Id cannot be changed', 16, 1)
  Return
 End
 
 -- If DeptName is updated
 if(Update(DeptName)) --HR 
 Begin
  Declare @DeptId int

  Select @DeptId = DeptId  
  from tblDepartment21
  join inserted
  on inserted.DeptName = tblDepartment21.DeptName --to set new name in dept table
  --first insert HR or any dept into dept table, collect 3 from there and store it into variable
 -- intention to change id in employee table not to change dept id 
  
  if(@DeptId is NULL )--if dept name garbage, no deptid so error
  Begin
   Raiserror('Invalid Department Name', 16, 1)
   Return
  End
  
  Update tblEmployee21 set DepartmentId = @DeptId
  from inserted
  join tblEmployee21
  on tblEmployee21.Id = inserted.id
 End
 
 -- If gender is updated
 if(Update(Gender))
 Begin
  Update tblEmployee21 set Gender = inserted.Gender
  from inserted
  join tblEmployee21
  on tblEmployee21.Id = inserted.id
 End
 
 -- If Name is updated
 if(Update([Name]))
 Begin
  Update tblEmployee21 set [Name] = inserted.[Name]
  from inserted
  join tblEmployee21
  on tblEmployee21.Id = inserted.id
 End
End

--Now, let's try to update JOHN's Department to IT. 


Update vWEmployeeDetails1  set DeptName = 'IT' where Id = 1

Update vWEmployeeDetails1 set DeptName = 'ITyruyrur' where Id = 1 -- throw errror after triggering , working fine


Select * from vWEmployeeDetails1 ----no update after triggering still HR, triggring not working 
Select * from tblEmployee22 
Select * from tblDepartment22

Update vWEmployeeDetails1 
set [Name] = 'Johny', Gender = 'Female', DeptName = 'IT' --no updation even after triggering
where Id = 1
Select * from vWEmployeeDetails1 
Select * from tblEmployee22 
Select * from tblDepartment22

